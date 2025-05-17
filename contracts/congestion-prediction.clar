;; Intersection Verification Contract
;; Validates traffic control points

(define-data-var admin principal tx-sender)
(define-map intersections {id: uint} {active: bool, location: (string-utf8 100), last-verified: uint})

;; Register a new intersection
(define-public (register-intersection (id uint) (location (string-utf8 100)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (asserts! (is-none (map-get? intersections {id: id})) (err u2))
    (map-set intersections {id: id} {active: true, location: location, last-verified: block-height})
    (ok true)
  )
)

;; Verify an intersection is operational
(define-public (verify-intersection (id uint))
  (let ((intersection (unwrap! (map-get? intersections {id: id}) (err u3))))
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u1))
      (map-set intersections
        {id: id}
        (merge intersection {last-verified: block-height})
      )
      (ok true)
    )
  )
)

;; Get intersection details
(define-read-only (get-intersection (id uint))
  (map-get? intersections {id: id})
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (var-set admin new-admin)
    (ok true)
  )
)
