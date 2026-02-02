"""
The query calculates the 7-day moving average of transfer amounts for each senders 
Client Vertical over the last 6 months. It includes only completed transfers and 
orders the results by ClientId and TransferTime. The moving average 
is calculated using a 7-day rolling window.
"""
SELECT
  c.ClientId,
  c.Vertical,
  it.TransferTime,
  AVG(it.Amt) OVER (
  PARTITION BY c.ClientId, c.Vertical
  ORDER BY it.TransferTime
  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS SevenDayMovingAvg
FROM
  InternalTransfers it
JOIN
  account s ON it.SenderAccountId = s.AccountId
JOIN
  Client c ON s.ClientId = c.ClientId
WHERE
  it.TransferStatus = 'Completed'
  AND it.TransferTime >= CURDATE() - INTERVAL 6 MONTH
ORDER BY
  c.ClientId, it.TransferTime;
