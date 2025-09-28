# Config Manager Module Documentation

**File**: `/home/bch/.claude/modules/config-manager.sh`
**Size**: 9.8k (334 lines)
**Purpose**: ADHD profile management and configuration loading system

## 🎯 Core Function

Manages personalized ADHD cognitive profiles with JSON-based configuration, providing thresholds and preferences for different ADHD presentations.

## 📁 File Structure

```bash
~/.claude/config/
├── adhd-profiles.json    # Master profiles (inattentive, hyperactive, combined, etc.)
└── user-config.json      # Personal overrides and current profile
```

## 🚀 CLI Commands

### Basic Commands
```bash
# Profile Management
~/.claude/modules/config-manager.sh list                    # Show all available profiles
~/.claude/modules/config-manager.sh current                 # Get active profile name
~/.claude/modules/config-manager.sh set hyperactive         # Switch to profile
~/.claude/modules/config-manager.sh describe inattentive    # Get profile description

# Validation & Testing
~/.claude/modules/config-manager.sh validate adaptive       # Test profile integrity
~/.claude/modules/config-manager.sh load combined           # Load full profile JSON
```

### Threshold Extraction
```bash
# Get specific configuration sections
~/.claude/modules/config-manager.sh hyperfocus adaptive     # Warning thresholds
~/.claude/modules/config-manager.sh energy gentle           # Energy level thresholds
~/.claude/modules/config-manager.sh context hyperactive     # Context switching limits
~/.claude/modules/config-manager.sh api inattentive         # API ratio thresholds
~/.claude/modules/config-manager.sh circadian default       # Circadian modifiers
~/.claude/modules/config-manager.sh visual sensitive        # Visual preferences
```

## 📊 Data Formats

### Input: Profile JSON Structure
```json
{
  "profiles": {
    "inattentive": {
      "description": "Lower switching tolerance, extended hyperfocus detection",
      "hyperfocus_warning": {
        "check_in_minutes": 75,
        "break_soon_minutes": 100,
        "break_now_minutes": 150
      },
      "energy_thresholds": {
        "high": 2.0,
        "medium": 1.0,
        "low": 0.4
      },
      "context_switching": {
        "scattered_threshold": 50,
        "switching_threshold": 25,
        "focused_threshold": 10
      },
      "api_ratio_thresholds": {
        "deep_focus": 6,
        "focused": 12,
        "scattered": 25
      },
      "visual_preferences": {
        "use_colors": true,
        "use_emojis": true,
        "use_progress_bars": false,
        "blink_critical_alerts": false
      }
    }
  }
}
```

### Output: Threshold Objects
```json
{
  "check_in": 90,
  "break_soon": 120,
  "break_now": 180
}
```

## 🔧 Key Functions

### `load_config(profile_name)`
- **Purpose**: Load complete profile configuration with validation
- **Input**: Profile name (defaults to "adaptive")
- **Output**: Complete profile JSON object
- **Error Handling**: Auto-fallback to "adaptive" if profile not found

### `get_hyperfocus_thresholds(profile_name)`
- **Purpose**: Extract hyperfocus warning timing thresholds
- **ADHD Feature**: Different profiles have different hyperfocus detection windows
- **Fallback Values**: `{check_in: 90, break_soon: 120, break_now: 180}`

### `get_energy_thresholds(profile_name)`
- **Purpose**: Get productivity velocity categorization thresholds
- **ADHD Feature**: Accounts for different energy patterns across presentations
- **Fallback Values**: `{high: 2.5, medium: 1.2, low: 0.5}`

### `validate_config(profile_name)`
- **Purpose**: Comprehensive profile validation with detailed output
- **ADHD Feature**: Shows all threshold values for verification
- **Output**: ✅/❌ validation results with specific values

## 🧠 ADHD-Specific Features

### Profile Differentiation
- **Inattentive**: Lower context switching tolerance, extended hyperfocus windows
- **Hyperactive**: Higher switching tolerance, shorter hyperfocus detection
- **Combined**: Balanced mixed-presentation settings
- **Sensitive**: Lower stimulation thresholds, reduced visual elements
- **Intensive**: Higher thresholds for intensive development periods

### Error Handling
- **Graceful Degradation**: Always provides fallback values
- **Auto-Correction**: Invalid profile names default to "adaptive"
- **JSON Validation**: Syntax checking before loading

### User Overrides
- **Personal Config**: `user-config.json` overrides system defaults
- **Profile Switching**: Live profile changes without restart
- **Custom Thresholds**: Individual threshold customization

## 🔌 Integration Points

### With Main Statusline
```bash
# Load active profile
current_profile=$(~/.claude/modules/config-manager.sh current)

# Get hyperfocus thresholds
thresholds=$(~/.claude/modules/config-manager.sh hyperfocus "$current_profile")
check_in=$(echo "$thresholds" | jq -r '.check_in')
```

### With Other Modules
```bash
# Energy assessment module uses energy thresholds
energy_config=$(~/.claude/modules/config-manager.sh energy "$profile")

# Context analyzer uses switching thresholds
context_config=$(~/.claude/modules/config-manager.sh context "$profile")
```

## 💡 Usage Examples

### Profile Setup
```bash
# List available profiles
~/.claude/modules/config-manager.sh list
# Output: adaptive, inattentive, hyperactive, combined, sensitive, intensive

# Switch to inattentive profile
~/.claude/modules/config-manager.sh set inattentive
# Output: Profile set to: inattentive

# Validate new profile
~/.claude/modules/config-manager.sh validate inattentive
# Output:
# ✅ Hyperfocus thresholds: {"check_in": 75, "break_soon": 100, "break_now": 150}
# ✅ Energy thresholds: {"high": 2.0, "medium": 1.0, "low": 0.4}
# ✅ Configuration validated successfully
```

### Threshold Extraction
```bash
# Get visual preferences for sensitive users
visual_prefs=$(~/.claude/modules/config-manager.sh visual sensitive)
use_emojis=$(echo "$visual_prefs" | jq -r '.use_emojis')
blink_alerts=$(echo "$visual_prefs" | jq -r '.blink_critical_alerts')

# Use in statusline logic
if [[ "$use_emojis" == "true" ]]; then
    indicator="🔋"
else
    indicator="[BAT]"
fi
```

### Integration Pattern
```bash
# Standard module initialization
current_profile=$(~/.claude/modules/config-manager.sh current)
energy_thresholds=$(~/.claude/modules/config-manager.sh energy "$current_profile")
visual_prefs=$(~/.claude/modules/config-manager.sh visual "$current_profile")

# Extract specific values
high_threshold=$(echo "$energy_thresholds" | jq -r '.high')
use_colors=$(echo "$visual_prefs" | jq -r '.use_colors')
```

## ⚠️ Error Conditions

### Missing Files
- **Profiles File Missing**: Returns error, suggests recreation
- **User Config Missing**: Auto-creates with defaults
- **Invalid JSON**: Returns parsing error with line information

### Invalid Profiles
- **Profile Not Found**: Auto-switches to "adaptive" with warning
- **Malformed Profile**: Returns fallback values, logs error
- **Missing Thresholds**: Uses hardcoded fallbacks

## 🎨 Visual Feedback

### Validation Output
```
✅ Hyperfocus thresholds: {"check_in": 90, "break_soon": 120, "break_now": 180}
✅ Energy thresholds: {"high": 2.5, "medium": 1.2, "low": 0.5}
✅ Context thresholds: {"scattered": 70, "switching": 40, "focused": 15}
✅ API thresholds: {"deep_focus": 8, "focused": 15, "scattered": 30}
✅ Visual preferences: {"use_colors":true,"use_emojis":true,"use_progress_bars":true}
✅ Configuration validated successfully
```

### Error Messages
```
Warning: Profile 'unknown' not found, using 'adaptive'
Error: Invalid JSON in profiles file
Error: Failed to load profile 'corrupted'
```

## 🔄 Return Codes

- **0**: Success
- **1**: Profile not found / JSON error / File missing
- **Auto-fallback**: Never fails completely, always provides usable configuration