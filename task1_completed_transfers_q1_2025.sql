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
JOIN account sacc ON it.SenderAccountId = sacc.AccountId
JOIN account racc ON it.ReceiverAccountId = racc.AccountId
JOIN "Group" sgrp ON sacc.GroupId = sgrp.GroupId
JOIN "Group" rgrp ON racc.GroupId = rgrp.GroupId
WHERE it.TransferStatus = 'Completed'
  AND it.TransferTime >= '2025-01-01'
  AND it.TransferTime <  '2025-04-01'
  AND sgrp.GroupPod != rgrp.GroupPod
ORDER BY it.TransferTime;
