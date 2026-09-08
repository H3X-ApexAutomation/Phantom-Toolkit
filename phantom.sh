#!/data/data/com.termux/files/usr/bin/bash

# ════════════════════════════════════════════════════════════
#  PHANTOM TOOLKIT - MAIN LAUNCHER
#  Version: 2.0.0
#  Author: Phantom Team
#  GitHub: H3X-ApexAutomation
#  Description: Main entry point for Phantom Toolkit
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
SKULL="💀"
FIRE="🔥"
SHIELD="🛡️"
EYE="👁️"

# ─── Setup ──────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ─── Source Core ────────────────────────────────────────────
source core/banner.sh 2>/dev/null || { echo -e "${RED}Error: core/banner.sh not found!${NC}"; exit 1; }
source core/menu.sh 2>/dev/null || { echo -e "${RED}Error: core/menu.sh not found!${NC}"; exit 1; }

# ─── Animated Functions ─────────────────────────────────────

# Animated rainbow text
rainbow_text() {
    local text="$1"
    local colors=("$RED" "$YELLOW" "$GREEN" "$CYAN" "$BLUE" "$PURPLE")
    local i=0
    
    for ((i=0; i<${#text}; i++)); do
        color_index=$((i % ${#colors[@]}))
        echo -ne "${colors[$color_index]}${text:$i:1}${NC}"
        sleep 0.02
    done
    echo ""
}

# Pulsing glow effect
pulse_glow() {
    local text="$1"
    local color="$2"
    
    for i in {1..3}; do
        echo -ne "\r${color}${BOLD}${text}   ${NC}"
        sleep 0.2
        echo -ne "\r${color}${DIM}${text}   ${NC}"
        sleep 0.2
    done
    echo ""
}

# Typewriter effect
typewriter() {
    local text="$1"
    local color="${2:-$CYAN}"
    
    echo -ne "${color}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep 0.03
    done
    echo -e "${NC}"
}

# Animated countdown
countdown() {
    local seconds=$1
    local msg=$2
    
    echo -ne "${YELLOW}${msg} "
    for ((i=seconds; i>0; i--)); do
        echo -ne "${BOLD}${i}${NC} "
        sleep 1
    done
    echo ""
}

# ─── Dependencies Check ─────────────────────────────────────

check_deps() {
    echo -e "${BLUE}${ARROW}${NC} ${DIM}Checking dependencies...${NC}"
    local missing=()
    local deps=("nmap" "curl" "jq")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${WARN} ${YELLOW}Missing dependencies: ${missing[*]}${NC}"
        echo -e "${ARROW} ${CYAN}Run option [5] to install them.${NC}"
        echo ""
        return 1
    fi
    
    echo -e "${CHECK} ${GREEN}All dependencies ready${NC}"
    echo ""
    return 0
}

# ─── Animated Menu Display ──────────────────────────────────

show_animated_menu() {
    echo ""
    
    # Animated menu border
    echo -e "${PURPLE}┌───────────────────────────────────────────────────────────┐${NC}"
    
    # Rainbow main menu title
    echo -ne "${PURPLE}│${NC} "
    rainbow_text "  MAIN MENU"
    echo -ne "${PURPLE}│${NC} "
    echo -e "${PURPLE}├───────────────────────────────────────────────────────────┤${NC}"
    
    # Menu items with icons and colors
    echo -e "${PURPLE}│${NC}  ${GREEN}[1]${NC} ${CYAN}📡${NC}  Reconnaissance Suite                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${GREEN}[2]${NC} ${CYAN}🛡️${NC}  Defense & Protection                        ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${GREEN}[3]${NC} ${CYAN}🤖${NC}  AI Threat Analysis                           ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${GREEN}[4]${NC} ${CYAN}📊${NC}  Generate Report                              ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${GREEN}[5]${NC} ${CYAN}⚙️${NC}  Utilities                                    ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${PURPLE}[6]${NC} ${CYAN}🎭${NC}  Ghost Mode (Stealth)                        ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${YELLOW}[7]${NC} ${CYAN}❓${NC}  Help                                         ${PURPLE}│${NC}"
    echo -e "${PURPLE}│${NC}  ${RED}[0]${NC} ${CYAN}🚪${NC}  Exit                                           ${PURPLE}│${NC}"
    
    echo -e "${PURPLE}└───────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# ─── Loading Animation ──────────────────────────────────────

loading_animation() {
    local msg="$1"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    echo -ne "${BLUE}${msg}${NC} "
    for i in {1..10}; do
        printf "\b${spin:$((i%10)):1}"
        sleep 0.1
    done
    echo -e "\b${CHECK} ${GREEN}Done!${NC}"
}

# ─── Module Loader with Animation ──────────────────────────

load_module() {
    local module="$1"
    local name="$2"
    
    echo ""
    typewriter "━━━ Loading ${name} ━━━" "$PURPLE"
    echo ""
    loading_animation "Initializing module"
    
    if [[ -f "$module" ]]; then
        bash "$module"
    else
        echo -e "${CROSS} ${RED}Module not found: $module${NC}"
        read -p "Press Enter to continue..."
    fi
}

# ─── Main Loop ──────────────────────────────────────────────

while true; do
    # Show animated banner
    show_banner
    
    # Check dependencies
    check_deps
    
    # Show animated menu
    show_animated_menu
    
    # Animated prompt
    echo -ne "${BOLD}${CYAN}${BLINK}➜${NC} ${BOLD}Select an option: ${NC}"
    read choice
    
    case $choice in
        1) 
            load_module "modules/recon/network.sh" "Reconnaissance Suite"
            ;;
        2) 
            load_module "modules/defense/phishing.sh" "Defense & Protection"
            ;;
        3) 
            load_module "modules/ai/threat-analyzer.sh" "AI Threat Analysis"
            ;;
        4) 
            load_module "modules/ai/report-gen.sh" "Report Generator"
            ;;
        5) 
            load_module "modules/utils/menu.sh" "Utilities"
            ;;
        6) 
            echo ""
            typewriter "━━━ Activating Ghost Mode ━━━" "$PURPLE"
            echo ""
            pulse_glow "👻 Becoming invisible..." "$PURPLE"
            bash core/ghost.sh
            ;;
        7) 
            echo ""
            typewriter "━━━ Phantom Toolkit Help ━━━" "$CYAN"
            echo ""
            echo -e "${YELLOW}📖 Phantom Toolkit v2.0${NC}"
            echo -e "${DIM}Developed by Phantom Team${NC}"
            echo -e "${DIM}GitHub: H3X-ApexAutomation${NC}"
            echo ""
            echo -e "${CYAN}Available Modules:${NC}"
            echo -e "  ${GREEN}[1]${NC} Reconnaissance - Network scanning, subdomain enumeration"
            echo -e "  ${GREEN}[2]${NC} Defense - Phishing detection, URL scanning"
            echo -e "  ${GREEN}[3]${NC} AI - Threat analysis with Gemini AI"
            echo -e "  ${GREEN}[4]${NC} Reports - Generate professional security reports"
            echo -e "  ${GREEN}[5]${NC} Utilities - Password generation, encryption"
            echo -e "  ${GREEN}[6]${NC} Ghost Mode - Stealth operations, log wiping"
            echo ""
            echo -e "${YELLOW}💡 Tips:${NC}"
            echo -e "  • Use ${BOLD}phantom${NC} or ${BOLD}pt${NC} to launch from anywhere"
            echo -e "  • Check ${BOLD}README.md${NC} for full documentation"
            echo -e "  • Star the repo if you like it! ⭐"
            echo ""
            echo -e "${PURPLE}🔗 GitHub: ${CYAN}https://github.com/H3X-ApexAutomation/PhantomToolkit${NC}"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        0) 
            echo ""
            echo -e "${GREEN}"
            for char in $(echo "  👻 Phantom fading into the shadows..." | fold -w1); do
                echo -ne "$char"
                sleep 0.05
            done
            echo -e "${NC}\n"
            
            # Animated countdown
            countdown 3 "Exiting in"
            echo ""
            echo -e "${PURPLE}👻 Stay stealthy!${NC}"
            exit 0
            ;;
        *) 
            echo ""
            echo -e "${CROSS} ${RED}Invalid option!${NC}"
            sleep 1
            ;;
    esac
done

# ─── End of Script ──────────────────────────────────────────
