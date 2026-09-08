#!/data/data/com.termux/files/usr/bin/bash

# ════════════════════════════════════════════════════════════
#  PHANTOM TOOLKIT - INSTALLER SCRIPT
#  Version: 2.0.0
#  Author: Phantom Team
#  Description: One-command installer for Phantom Toolkit
# ════════════════════════════════════════════════════════════

# ─── Colors ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'
NC='\033[0m'

# ─── Icons ──────────────────────────────────────────────────
CHECK="✅"
CROSS="❌"
WARN="⚠️"
INFO="ℹ️"
ARROW="➜"
STAR="⭐"
GHOST="👻"
CRYSTAL="🔮"

# ─── Variables ─────────────────────────────────────────────
REPO_URL="https://github.com/YOUR_USERNAME/PhantomToolkit.git"
INSTALL_DIR="$HOME/PhantomToolkit"
SCRIPT_NAME="phantom.sh"
ALIAS_NAME="phantom"
ALIAS_SHORT="pt"

# ─── Animated Functions ─────────────────────────────────────

# Animated banner with typewriter effect
animate_banner() {
    clear
    echo -e "${PURPLE}"
    
    # Line by line with delay for typewriter effect
    lines=(
        "    ╔═══════════════════════════════════════════════════════════════╗"
        "    ║                                                               ║"
        "    ║    ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗"
        "    ║    ██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║"
        "    ║    ██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║"
        "    ║    ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║"
        "    ║    ██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║"
        "    ║    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝"
        "    ║                                                               ║"
        "    ║              🔮 PHANTOM TOOLKIT v2.0                         ║"
        "    ║           The Ghost in Your Terminal                         ║"
        "    ║                                                               ║"
        "    ╚═══════════════════════════════════════════════════════════════╝"
    )
    
    for line in "${lines[@]}"; do
        echo -e "$line"
        sleep 0.03
    done
    
    echo -e "${NC}"
    
    # Animated subtitle with typing effect
    echo -ne "${BOLD}${CYAN}   ═══ "
    for char in $(echo "The Ghost in Your Terminal" | fold -w1); do
        echo -ne "$char"
        sleep 0.05
    done
    echo -e " ═══${NC}\n"
    sleep 0.5
}

# Spinner animation
spinner() {
    local pid=$1
    local label=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r${BLUE}${spin:$i:1}${NC} ${DIM}${label}${NC}   "
        sleep 0.1
    done
    printf "\r${CHECK} ${GREEN}Done${NC}     \n"
}

# Animated progress bar with color cycling
animate_progress() {
    local current=$1
    local total=$2
    local label=$3
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    # Color cycling based on progress
    if [[ $percent -lt 33 ]]; then
        color=$RED
    elif [[ $percent -lt 66 ]]; then
        color=$YELLOW
    else
        color=$GREEN
    fi
    
    printf "\r${BLUE}[${NC}"
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "${BLUE}]${NC} ${color}%3d%%${NC} ${DIM}${label}${NC}" "$percent"
}

# Pulse animation for waiting
pulse() {
    local msg=$1
    for i in {1..3}; do
        echo -ne "\r${BLUE}${ARROW}${NC} ${msg}   "
        sleep 0.3
        echo -ne "\r${BLUE}${ARROW}${NC} ${msg} .  "
        sleep 0.3
        echo -ne "\r${BLUE}${ARROW}${NC} ${msg} .. "
        sleep 0.3
        echo -ne "\r${BLUE}${ARROW}${NC} ${msg} ..."
        sleep 0.3
    done
    echo ""
}

# ─── Core Functions ─────────────────────────────────────────

# Check if running in Termux
check_termux() {
    echo -e "\n${BLUE}${ARROW}${NC} ${BOLD}Checking environment...${NC}"
    pulse "Verifying system"
    
    if [[ ! -d "/data/data/com.termux" ]]; then
        echo -e "\n${CROSS} ${RED}This script must be run in Termux!${NC}"
        echo -e "${WARN} ${YELLOW}Please install Termux from F-Droid:${NC}"
        echo -e "    ${CYAN}https://f-droid.org/en/packages/com.termux/${NC}"
        exit 1
    fi
    echo -e "\r${CHECK} ${GREEN}Termux detected           ${NC}\n"
}

# Check internet connection
check_internet() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Checking internet connection...${NC}"
    
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        echo -e "${CHECK} ${GREEN}Internet connected${NC}\n"
    else
        echo -e "${WARN} ${YELLOW}No internet connection detected${NC}"
        echo -e "${INFO} ${DIM}Some features may require internet${NC}\n"
    fi
}

# Update packages with animation
update_packages() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Updating package lists...${NC}"
    
    (
        pkg update -y 2>/dev/null
    ) &
    spinner $! "Refreshing repositories"
    
    echo -e "${CHECK} ${GREEN}Packages updated${NC}\n"
}

# Install dependencies with animated progress
install_deps() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Installing dependencies...${NC}\n"
    
    local deps=("nmap" "curl" "jq" "git" "python" "wget" "openssl" "figlet" "toilet")
    local total=${#deps[@]}
    local current=0
    
    for dep in "${deps[@]}"; do
        current=$((current + 1))
        animate_progress "$current" "$total" "Installing $dep..."
        pkg install "$dep" -y &>/dev/null
    done
    echo ""
    echo -e "${CHECK} ${GREEN}All dependencies installed${NC}\n"
}

# Clone repository with animation
clone_repo() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Cloning Phantom Toolkit...${NC}"
    
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${WARN} ${YELLOW}PhantomToolkit already exists${NC}"
        echo -ne "${ARROW} ${CYAN}Overwrite? (y/n): ${NC}"
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
            echo -e "${INFO} ${DIM}Removed existing directory${NC}"
        else
            echo -e "${INFO} ${DIM}Keeping existing installation${NC}"
            return 0
        fi
    fi
    
    (
        git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" &>/dev/null
    ) &
    spinner $! "Downloading files"
    
    echo -e "${CHECK} ${GREEN}Repository cloned${NC}\n"
}

# Set permissions
set_permissions() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Setting permissions...${NC}"
    
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null
    chmod +x "$INSTALL_DIR/core/"*.sh 2>/dev/null
    chmod +x "$INSTALL_DIR/modules/"*/*.sh 2>/dev/null
    chmod +x "$INSTALL_DIR/modules/"*.sh 2>/dev/null
    
    echo -e "${CHECK} ${GREEN}Permissions set${NC}\n"
}

# Create directories
create_dirs() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Creating directories...${NC}"
    
    mkdir -p "$INSTALL_DIR/config"
    mkdir -p "$INSTALL_DIR/reports"
    mkdir -p "$INSTALL_DIR/wordlists"
    mkdir -p "$INSTALL_DIR/logs"
    
    echo -e "${CHECK} ${GREEN}Directories created${NC}\n"
}

# Setup config with animation
setup_config() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Setting up configuration...${NC}"
    
    # Create settings.conf
    cat > "$INSTALL_DIR/config/settings.conf" << 'EOF'
# ─── PHANTOM TOOLKIT SETTINGS ───
# Generated by Phantom Team

# General Settings
PHANTOM_VERSION="2.0.0"
PHANTOM_MODE="normal"  # normal | stealth | paranoid

# Feature Toggles
ENABLE_AI=true
ENABLE_REPORTS=true
ENABLE_LOGGING=true
ENABLE_STEALTH=false

# Report Settings
REPORT_FORMAT="txt"  # txt | pdf | html
REPORT_AUTO_SAVE=true

# Log Settings
LOG_LEVEL="info"  # debug | info | warn | error
LOG_RETENTION_DAYS=7

# Network Settings
DEFAULT_SCAN_TIMEOUT=30
DEFAULT_SCAN_PORTS="1-1000"
EOF
    
    # Create api_keys.conf
    cat > "$INSTALL_DIR/config/api_keys.conf" << 'EOF'
# ─── PHANTOM TOOLKIT API KEYS ───
# Add your API keys below (remove # to enable)
# Get free keys at the URLs provided

# Gemini AI (Free: https://makersuite.google.com/app/apikey)
# GEMINI_API_KEY="your-api-key-here"

# VirusTotal (Free: https://www.virustotal.com/gui/join-us)
# VIRUSTOTAL_API_KEY="your-api-key-here"

# Shodan (https://account.shodan.io/register)
# SHODAN_API_KEY="your-api-key-here"
EOF
    
    echo -e "${CHECK} ${GREEN}Configuration created${NC}\n"
}

# Setup alias
setup_alias() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Setting up aliases...${NC}"
    
    if ! grep -q "alias $ALIAS_NAME=" ~/.bashrc 2>/dev/null; then
        echo "alias $ALIAS_NAME='~/PhantomToolkit/$SCRIPT_NAME'" >> ~/.bashrc
        echo "alias $ALIAS_SHORT='~/PhantomToolkit/$SCRIPT_NAME'" >> ~/.bashrc
        echo -e "${CHECK} ${GREEN}Aliases added: ${CYAN}$ALIAS_NAME${NC} and ${CYAN}$ALIAS_SHORT${NC}"
    else
        echo -e "${INFO} ${DIM}Aliases already exist${NC}"
    fi
    echo ""
}

# Setup API key (optional) with animation
setup_api() {
    echo -e "${BLUE}${ARROW}${NC} ${BOLD}Optional: Gemini AI Setup${NC}"
    echo -e "${DIM}Get a free API key at: https://makersuite.google.com/app/apikey${NC}"
    echo -ne "${ARROW} ${CYAN}Enter Gemini API key (or press Enter to skip): ${NC}"
    read api_key
    
    if [[ -n "$api_key" ]]; then
        sed -i "s/# GEMINI_API_KEY=.*/GEMINI_API_KEY=\"$api_key\"/" "$INSTALL_DIR/config/api_keys.conf"
        echo -e "${CHECK} ${GREEN}API key saved${NC}"
    else
        echo -e "${INFO} ${DIM}Skipped API setup${NC}"
    fi
    echo ""
}

# ─── Animated Success Message ──────────────────────────────

show_success() {
    clear
    
    # Animated celebration banner
    echo -e "${GREEN}"
    for i in {1..5}; do
        echo -ne "${BOLD}╔═══════════════════════════════════════════════════════════════╗\r"
        sleep 0.05
    done
    echo -e "╔═══════════════════════════════════════════════════════════════╗"
    
    echo -e "║                                                               ║"
    echo -e "║  ${BOLD}${CHECK} INSTALLATION COMPLETE!                         ${NC}${GREEN}║"
    echo -e "║                                                               ║"
    echo -e "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Typewriter effect for main message
    echo -ne "${BOLD}${PURPLE}"
    for char in $(echo "  👻 Phantom Toolkit v2.0" | fold -w1); do
        echo -ne "$char"
        sleep 0.03
    done
    echo -e "${NC}"
    
    echo -ne "${BOLD}${CYAN}"
    for char in $(echo "  The Ghost in Your Terminal" | fold -w1); do
        echo -ne "$char"
        sleep 0.03
    done
    echo -e "${NC}\n"
    
    # Blinking quick start
    echo -e "${BOLD}${YELLOW}${BLINK}🚀 QUICK START${NC}"
    echo -e "   ${ARROW} ${CYAN}Run directly:${NC}  ${BOLD}./phantom.sh${NC} ${DIM}(from install directory)${NC}"
    echo -e "   ${ARROW} ${CYAN}Use alias:${NC}     ${BOLD}phantom${NC} ${DIM}(or ${BOLD}pt${NC}${DIM} for short)${NC}"
    echo -e "   ${ARROW} ${CYAN}Reload shell:${NC}  ${BOLD}source ~/.bashrc${NC}"
    echo ""
    
    echo -e "${BOLD}${YELLOW}📂 Installation Location:${NC}"
    echo -e "   ${DIM}$INSTALL_DIR${NC}"
    echo ""
    
    echo -e "${BOLD}${YELLOW}📚 Documentation:${NC}"
    echo -e "   ${ARROW} ${CYAN}GitHub:${NC} ${DIM}$REPO_URL${NC}"
    echo -e "   ${ARROW} ${CYAN}README:${NC} ${DIM}cat ~/PhantomToolkit/README.md${NC}"
    echo ""
    
    echo -e "${BOLD}${PURPLE}💖 Support Phantom Team:${NC}"
    echo -e "   ${ARROW} ${CYAN}Star on GitHub:${NC} ${DIM}https://github.com/YOUR_USERNAME/PhantomToolkit${NC}"
    echo -e "   ${ARROW} ${CYAN}Sponsor:${NC}        ${DIM}https://github.com/sponsors/YOUR_USERNAME${NC}"
    echo ""
    
    # Animated ghost farewell
    echo -ne "${BOLD}${GREEN}"
    for char in $(echo "  Happy hacking! 👻" | fold -w1); do
        echo -ne "$char"
        sleep 0.05
    done
    echo -e "${NC}\n"
}

# ─── Main Installation ──────────────────────────────────────

main() {
    # Animated banner
    animate_banner
    
    # Check if running in Termux
    check_termux
    
    # Check internet
    check_internet
    
    # Update packages
    update_packages
    
    # Install dependencies with progress
    install_deps
    
    # Clone repository
    clone_repo
    
    # Set permissions
    set_permissions
    
    # Create directories
    create_dirs
    
    # Setup configuration
    setup_config
    
    # Setup alias
    setup_alias
    
    # Setup API (optional)
    setup_api
    
    # Show animated success message
    show_success
}

# ─── Run Main ──────────────────────────────────────────────

# Trap CTRL+C
trap 'echo -e "\n${RED}Installation cancelled${NC}"; exit 1' INT

# Run installation
main

# ─── End of Script ──────────────────────────────────────────
