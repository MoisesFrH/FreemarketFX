"""
The query sums all transfer amounts normalized to GBP for 2024, including only clients 
in the 'Gambling' vertical with at least one live account. Results are 
grouped by client and ordered by client name.
"""
SELECT
    c.ClientId,
    c.ClientName,
    SUM(
        CASE it.Currency
            WHEN 'GBP' THEN it.Amt
            ELSE it.Amt * der.Rate
        END
    ) AS GBP_Normalized_Amt
FROM InternalTransfers it
JOIN account a ON it.SenderAccountId = a.AccountId
JOIN Client c ON a.ClientId = c.ClientId
JOIN DailyExchangeRate der 
    ON it.Currency = der.FromCurrency
   AND der.ToCurrency = 'GBP'
   AND it.TransferTime = der.Date
WHERE it.TransferStatus = 'Completed'
  AND it.TransferTime >= '2024-01-01'
  AND it.TransferTime <  '2025-01-01'
  AND c.Vertical = 'Gambling'
  AND EXISTS (
        SELECT 1
        FROM account a2
        WHERE a2.ClientId = c.ClientId
          AND a2.AccountStatus = 'Live'
  )
GROUP BY c.ClientId, c.ClientName
ORDER BY c.ClientName;

