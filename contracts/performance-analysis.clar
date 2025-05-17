;; Performance Analytics Contract
;; Tracks system efficiency

(define-data-var admin principal tx-sender)
(define-map system-metrics
  {timestamp: uint}
  {
    total-intersections: uint,
    avg-response-time: uint,
    congestion-reduction: uint,
    energy-savings: uint
  }
)

;; Record system metrics
(define-public (record-metrics
  (total-intersections uint)
  (avg-response-time uint)
  (congestion-reduction uint)
  (energy-savings uint)
)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (map-set system-metrics
      {timestamp: block-height}
      {
        total-intersections: total-intersections,
        avg-response-time: avg-response-time,
        congestion-reduction: congestion-reduction,
        energy-savings: energy-savings
      }
    )
    (ok true)
  )
)

;; Get system metrics for a specific time
(define-read-only (get-metrics (timestamp uint))
  (map-get? system-metrics {timestamp: timestamp})
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (var-set admin new-admin)
    (ok true)
  )
)
