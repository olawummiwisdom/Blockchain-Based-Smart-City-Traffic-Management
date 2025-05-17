;; Signal Optimization Contract
;; Manages traffic light timing

(define-data-var admin principal tx-sender)
(define-map signal-timings
  {intersection-id: uint}
  {green-duration: uint, yellow-duration: uint, red-duration: uint, last-updated: uint}
)

;; Set signal timing for an intersection
(define-public (set-signal-timing
  (intersection-id uint)
  (green-duration uint)
  (yellow-duration uint)
  (red-duration uint)
)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (map-set signal-timings
      {intersection-id: intersection-id}
      {
        green-duration: green-duration,
        yellow-duration: yellow-duration,
        red-duration: red-duration,
        last-updated: block-height
      }
    )
    (ok true)
  )
)

;; Get signal timing for an intersection
(define-read-only (get-signal-timing (intersection-id uint))
  (map-get? signal-timings {intersection-id: intersection-id})
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (var-set admin new-admin)
    (ok true)
  )
)
