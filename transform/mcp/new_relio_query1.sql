-- Primary dashboard query: Apdex with correlated causal metrics
-- Alerts occurred at: 12:18-12:30, 06:36-06:39, 01:09-01:15
-- Objective: Identify root cause of Apdex < 0.7 breaches

-- QUERY 1: Apdex + Response Time + Error Rate (main diagnostic view)
SELECT
    apdex(apm.service.apdex) as 'Apdex',
    average(apm.service.transaction.duration) * 1000 as 'Avg Response Time (ms)',
    rate(sum(apm.service.error.count), 1 minute) as 'Errors/min'
FROM Metric
WHERE entity.guid = 'NjIwNzYwM3xBUE18QVBQTElDQVRJT058NDE2NjM4Mzc2'
TIMESERIES 3 MINUTES
SINCE '2026-06-21 00:15:00' UNTIL '2026-06-21 13:21:00'

-- QUERY 2: Throughput + External Service Latency (capacity/dependency view)
SELECT
    rate(sum(apm.service.transaction.count), 1 minute) as 'Requests/min',
    average(apm.service.external.duration) * 1000 as 'External Call Latency (ms)',
    average(apm.service.datastore.duration) * 1000 as 'Database Latency (ms)'
FROM Metric
WHERE entity.guid = 'NjIwNzYwM3xBUE18QVBQTElDQVRJT058NDE2NjM4Mzc2'
TIMESERIES 3 MINUTES
SINCE '2026-06-21 00:15:00' UNTIL '2026-06-21 13:21:00'

-- QUERY 3: HTTP Response Codes (error type breakdown - bar/area chart)
SELECT count(*)
FROM Transaction
WHERE entityGuid = 'NjIwNzYwM3xBUE18QVBQTElDQVRJT058NDE2NjM4Mzc2'
FACET CASES(
    WHERE http.statusCode >= 500 as '5xx Server Errors',
    WHERE http.statusCode >= 400 AND http.statusCode < 500 as '4xx Client Errors',
    WHERE http.statusCode >= 200 AND http.statusCode < 300 as '2xx Success'
)
TIMESERIES 3 MINUTES
SINCE '2026-06-21 00:15:00' UNTIL '2026-06-21 13:21:00'

-- QUERY 4: Infrastructure metrics if available (CPU/Memory correlation)
SELECT
    average(cpuPercent) as 'CPU %',
    average(memoryUsedPercent) as 'Memory %'
FROM SystemSample
WHERE entityGuid IN (
    SELECT uniques(infrastructureEntityGuid)
    FROM Relationship
    WHERE sourceEntityGuid = 'NjIwNzYwM3xBUE18QVBQTElDQVRJT058NDE2NjM4Mzc2'
)
TIMESERIES 3 MINUTES
SINCE '2026-06-21 00:15:00' UNTIL '2026-06-21 13:21:00'

-- QUERY 5: Slowest transactions during alert windows (point/event data)
SELECT average(duration) * 1000 as 'Duration (ms)', count(*) as 'Count'
FROM Transaction
WHERE entityGuid = 'NjIwNzYwM3xBUE18QVBQTElDQVRJT058NDE2NjM4Mzc2'
AND (
    (timestamp BETWEEN 1750501080000 AND 1750501800000) OR  -- 12:18-12:30
    (timestamp BETWEEN 1750480560000 AND 1750480740000) OR  -- 06:36-06:39
    (timestamp BETWEEN 1750460940000 AND 1750461300000)     -- 01:09-01:15
)
FACET name
LIMIT 10
