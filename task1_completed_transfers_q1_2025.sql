"""
Return all rows of completed internal transfers made during Q1 2025 
where the Sender and Receiver belong to different GroupPods.
"""
SELECT
    it.SenderAccountId,
    it.ReceiverAccountId,
    it.Amt,
    it.Currency,
    it.TransferStatus,
    it.TransferTime,
    sgrp.GroupPod AS SenderGroupPod,
    rgrp.GroupPod AS ReceiverGroupPod
FROM InternalTransfers it

-- Sender side
JOIN Account sacc
  ON it.SenderAccountId = sacc.AccountId
JOIN Client scli
  ON sacc.ClientId = scli.ClientId
JOIN "Group" sgrp
  ON scli.GroupId = sgrp.GroupId

-- Receiver side
JOIN Account racc
  ON it.ReceiverAccountId = racc.AccountId
JOIN Client rcli
  ON racc.ClientId = rcli.ClientId
JOIN "Group" rgrp
  ON rcli.GroupId = rgrp.GroupId

WHERE it.TransferStatus = 'completed'
  AND it.TransferTime >= '2025-01-01'
  AND it.TransferTime <  '2025-04-01'
  AND sgrp.GroupPod <> rgrp.GroupPod
ORDER BY it.TransferTime;
