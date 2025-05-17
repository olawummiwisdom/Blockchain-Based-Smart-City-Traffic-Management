;; Vehicle Detection Contract
;; Records traffic volume and flow

(define-data-var admin principal tx-sender)
(define-map traffic-data
  {intersection-id: uint, timestamp: uint}
  {vehicle-count: uint, avg-speed: uint}
)

;; Record traffic data for an intersection
(define-public (record-traffic (intersection-id uint) (vehicle-count uint) (avg-speed uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (map-set traffic-data
      {intersection-id: intersection-id, timestamp: block-height}
      {vehicle-count: vehicle-count, avg-speed: avg-speed}
    )
    (ok true)
  )
)

;; Get traffic data for a specific time
(define-read-only (get-traffic-data (intersection-id uint) (timestamp uint))
  (map-get? traffic-data {intersection-id: intersection-id, timestamp: timestamp})
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (var-set admin new-admin)
    (ok true)
  )
)
