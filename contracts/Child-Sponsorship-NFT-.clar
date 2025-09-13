


(define-non-fungible-token child-sponsorship-nft uint)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-child-not-found (err u102))
(define-constant err-already-sponsored (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-milestone-not-found (err u105))
(define-constant err-unauthorized (err u106))
(define-constant err-invalid-child-id (err u107))
(define-constant err-insufficient-funds (err u108))

(define-data-var last-token-id uint u0)
(define-data-var last-child-id uint u0)
(define-data-var monthly-payment-amount uint u1000000)
(define-data-var contract-balance uint u0)

(define-map child-profiles 
  uint 
  {
    name: (string-ascii 50),
    age: uint,
    location: (string-ascii 100),
    education-level: (string-ascii 50),
    sponsor: (optional principal),
    sponsorship-start: (optional uint),
    total-received: uint,
    active: bool
  }
)

(define-map sponsorship-records
  uint
  {
    sponsor: principal,
    child-id: uint,
    monthly-amount: uint,
    total-paid: uint,
    last-payment: uint,
    active: bool
  }
)

(define-map child-milestones
  {child-id: uint, milestone-id: uint}
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    completion-date: (optional uint),
    verified: bool,
    verifier: (optional principal)
  }
)

(define-map milestone-counter uint uint)

(define-map payment-history
  {sponsor: principal, child-id: uint, payment-id: uint}
  {
    amount: uint,
    timestamp: uint,
    payment-type: (string-ascii 20)
  }
)

(define-map payment-counter {sponsor: principal, child-id: uint} uint)

(define-public (register-child (name (string-ascii 50)) (age uint) (location (string-ascii 100)) (education-level (string-ascii 50)))
  (let 
    (
      (child-id (+ (var-get last-child-id) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set child-profiles child-id
      {
        name: name,
        age: age,
        location: location,
        education-level: education-level,
        sponsor: none,
        sponsorship-start: none,
        total-received: u0,
        active: true
      }
    )
    (var-set last-child-id child-id)
    (map-set milestone-counter child-id u0)
    (ok child-id)
  )
)

(define-public (sponsor-child (child-id uint))
  (let 
    (
      (token-id (+ (var-get last-token-id) u1))
      (child-data (unwrap! (map-get? child-profiles child-id) err-child-not-found))
    )
    (asserts! (get active child-data) err-child-not-found)
    (asserts! (is-none (get sponsor child-data)) err-already-sponsored)
    (try! (nft-mint? child-sponsorship-nft token-id tx-sender))
    (map-set child-profiles child-id
      (merge child-data {
        sponsor: (some tx-sender),
        sponsorship-start: (some stacks-block-height)
      })
    )
    (map-set sponsorship-records token-id
      {
        sponsor: tx-sender,
        child-id: child-id,
        monthly-amount: (var-get monthly-payment-amount),
        total-paid: u0,
        last-payment: u0,
        active: true
      }
    )
    (map-set payment-counter {sponsor: tx-sender, child-id: child-id} u0)
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (make-payment (token-id uint))
  (let 
    (
      (sponsorship (unwrap! (map-get? sponsorship-records token-id) err-not-token-owner))
      (child-id (get child-id sponsorship))
      (child-data (unwrap! (map-get? child-profiles child-id) err-child-not-found))
      (payment-amount (get monthly-amount sponsorship))
      (payment-count (default-to u0 (map-get? payment-counter {sponsor: tx-sender, child-id: child-id})))
    )
    (asserts! (is-eq tx-sender (get sponsor sponsorship)) err-not-token-owner)
    (asserts! (get active sponsorship) err-unauthorized)
    (asserts! (>= (stx-get-balance tx-sender) payment-amount) err-insufficient-funds)
    (try! (stx-transfer? payment-amount tx-sender (as-contract tx-sender)))
    (map-set child-profiles child-id
      (merge child-data {
        total-received: (+ (get total-received child-data) payment-amount)
      })
    )
    (map-set sponsorship-records token-id
      (merge sponsorship {
        total-paid: (+ (get total-paid sponsorship) payment-amount),
        last-payment: stacks-block-height
      })
    )
    (map-set payment-history {sponsor: tx-sender, child-id: child-id, payment-id: (+ payment-count u1)}
      {
        amount: payment-amount,
        timestamp: stacks-block-height,
        payment-type: "monthly"
      }
    )
    (map-set payment-counter {sponsor: tx-sender, child-id: child-id} (+ payment-count u1))
    (var-set contract-balance (+ (var-get contract-balance) payment-amount))
    (ok true)
  )
)

(define-public (add-milestone (child-id uint) (title (string-ascii 100)) (description (string-ascii 500)))
  (let 
    (
      (milestone-count (default-to u0 (map-get? milestone-counter child-id)))
      (milestone-id (+ milestone-count u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-some (map-get? child-profiles child-id)) err-child-not-found)
    (map-set child-milestones {child-id: child-id, milestone-id: milestone-id}
      {
        title: title,
        description: description,
        completion-date: none,
        verified: false,
        verifier: none
      }
    )
    (map-set milestone-counter child-id milestone-id)
    (ok milestone-id)
  )
)

(define-public (verify-milestone (child-id uint) (milestone-id uint))
  (let 
    (
      (milestone-key {child-id: child-id, milestone-id: milestone-id})
      (milestone (unwrap! (map-get? child-milestones milestone-key) err-milestone-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set child-milestones milestone-key
      (merge milestone {
        completion-date: (some stacks-block-height),
        verified: true,
        verifier: (some tx-sender)
      })
    )
    (ok true)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (nft-transfer? child-sponsorship-nft token-id sender recipient)
  )
)

(define-public (set-monthly-payment (new-amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> new-amount u0) err-invalid-amount)
    (var-set monthly-payment-amount new-amount)
    (ok true)
  )
)

(define-public (deactivate-child (child-id uint))
  (let 
    (
      (child-data (unwrap! (map-get? child-profiles child-id) err-child-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set child-profiles child-id
      (merge child-data {active: false})
    )
    (ok true)
  )
)

(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? child-sponsorship-nft token-id))
)

(define-read-only (get-child-profile (child-id uint))
  (ok (map-get? child-profiles child-id))
)

(define-read-only (get-sponsorship-record (token-id uint))
  (ok (map-get? sponsorship-records token-id))
)

(define-read-only (get-milestone (child-id uint) (milestone-id uint))
  (ok (map-get? child-milestones {child-id: child-id, milestone-id: milestone-id}))
)

(define-read-only (get-payment-history (sponsor principal) (child-id uint) (payment-id uint))
  (ok (map-get? payment-history {sponsor: sponsor, child-id: child-id, payment-id: payment-id}))
)

(define-read-only (get-monthly-payment-amount)
  (ok (var-get monthly-payment-amount))
)

(define-read-only (get-contract-balance)
  (ok (var-get contract-balance))
)

(define-read-only (get-milestone-count (child-id uint))
  (ok (default-to u0 (map-get? milestone-counter child-id)))
)

(define-read-only (get-payment-count (sponsor principal) (child-id uint))
  (ok (default-to u0 (map-get? payment-counter {sponsor: sponsor, child-id: child-id})))
)

