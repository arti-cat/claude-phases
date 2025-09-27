# Claude Code OpenTelemetry Data Streams

## Overview
OpenTelemetry provides real-time metrics and logs for monitoring Claude Code usage patterns, performance, and behavioral data crucial for ADHD cognitive analysis.

## Configuration & Enablement

### Basic Configuration
```bash
# Enable telemetry
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# Configure exporters
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp

# Set endpoint
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

### Advanced Configuration
```bash
# Different endpoints for metrics and logs
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=http/protobuf
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://metrics.company.com:4318
export OTEL_EXPORTER_OTLP_LOGS_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://logs.company.com:4317
```

## Export Intervals & Timing

### Default Intervals
- **Metrics**: 60 seconds (60000ms)
- **Logs**: 5 seconds (5000ms)

### ADHD-Optimized Intervals
```bash
# High-frequency monitoring for cognitive analysis
export OTEL_METRIC_EXPORT_INTERVAL=10000  # 10 seconds
export OTEL_LOGS_EXPORT_INTERVAL=1000     # 1 second
```

### Debug Intervals
```bash
# Real-time debugging
export OTEL_METRIC_EXPORT_INTERVAL=1000   # 1 second
export OTEL_LOGS_EXPORT_INTERVAL=500      # 0.5 seconds
```

## Data Types & Formats

### Metrics Data
**Performance Metrics**:
- API response times
- Token usage rates
- Session duration tracking
- Cost accumulation patterns

**Behavioral Metrics**:
- Tool usage frequency
- Directory change patterns
- File operation rates
- Context switching frequency

### Logs Data
**Operational Logs**:
- Session start/end events
- Tool execution logs
- Error and warning events
- Permission denial logs

**User Behavior Logs**:
- Prompt submission patterns
- Response interaction timing
- Navigation behavior

## Exporter Options

### Console Exporter (Development)
```bash
export OTEL_METRICS_EXPORTER=console
export OTEL_LOGS_EXPORTER=console
export OTEL_METRIC_EXPORT_INTERVAL=1000  # Real-time console output
```

### OTLP Exporter (Production)
```bash
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://collector.example.com:4317
```

### Prometheus Exporter (Metrics Only)
```bash
export OTEL_METRICS_EXPORTER=prometheus
# Prometheus scrapes metrics directly from Claude Code
```

### Multiple Exporters
```bash
export OTEL_METRICS_EXPORTER=console,otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=http/json
```

## Authentication & Security

### Bearer Token Authentication
```bash
export OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer your-token"
```

### Multiple Headers
```bash
export OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer token,X-API-Key=key123"
```

### Dynamic Headers (via Script)
```json
{
  "otelHeadersHelper": "/bin/generate_opentelemetry_headers.sh"
}
```

Script example:
```bash
#!/bin/bash
echo "{\"Authorization\": \"Bearer $(get-token.sh)\", \"X-API-Key\": \"$(get-api-key.sh)\"}"
```

## User Prompt Logging

### Enable Prompt Content Logging
```bash
export OTEL_LOG_USER_PROMPTS=1
```

**Privacy Note**: Only enable if compliant with privacy policies.

## ADHD-Specific Monitoring Patterns

### Focus State Tracking
- **Sustained Activity**: Long periods of consistent tool usage
- **Context Switching**: Frequency of directory/file changes
- **Deep Work**: Extended API usage without interruption

### Energy Level Indicators
- **Response Velocity**: Time between user prompts
- **Tool Usage Intensity**: Operations per minute
- **Error Patterns**: Increased errors indicating fatigue

### Hyperfocus Detection
- **Extended Sessions**: Continuous activity >2 hours
- **High Tool Usage**: Above-average operations per hour
- **Low Context Switching**: Minimal directory changes

## Data Collection Examples

### Real-time Console Monitoring
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console
export OTEL_LOGS_EXPORTER=console
export OTEL_METRIC_EXPORT_INTERVAL=5000
claude
```

### Production Data Collection
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_ENDPOINT=http://your-collector:4317
export OTEL_METRIC_EXPORT_INTERVAL=30000  # 30-second intervals
claude
```

### Metrics-Only Collection (Lightweight)
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
# No logs exporter = metrics only
export OTEL_EXPORTER_OTLP_ENDPOINT=http://metrics-only-endpoint:4317
```

## Integration with ADHD Statusline

### Environment Variable Access
OpenTelemetry metrics can be accessed by statusline scripts through environment variables or by consuming the same OTLP endpoints.

### Real-time Cognitive State
Combine OpenTelemetry data with statusline JSON for comprehensive cognitive state assessment:

```bash
# In statusline script
input=$(cat)
session_duration=$(echo "$input" | jq -r '.cost.total_duration_ms')

# Correlate with OpenTelemetry metrics
# (requires OTLP consumer or shared data store)
```

## Troubleshooting

### Verify Configuration
```bash
env | grep OTEL_
env | grep CLAUDE_CODE_ENABLE_TELEMETRY
```

### Test Console Output
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console
export OTEL_METRIC_EXPORT_INTERVAL=1000
claude -p "test" --non-interactive
```

### Check Endpoint Connectivity
```bash
curl -v http://your-otlp-endpoint:4317/v1/metrics
```