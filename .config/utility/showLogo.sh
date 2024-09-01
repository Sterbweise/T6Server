# Function to display the showLogo
# This function prints a stylized ASCII art showLogo for the T6 Server Installer
showshowLogo() {
    stty igncr
    clear
    printf "${RED}


                                   .        ,;                            ,;           
                ${WHITE}j,${RED}                ;W      f#i j.                        f#i j.         
 GEEEEEEEL     ${WHITE}L#,${RED}               f#E    .E#t  EW,                     .E#t  EW,        
 ,;;L#K;;.    ${WHITE}D#D${RED}              .E#f    i#W,   E##j       t      .DD. i#W,   E##j       
    t#E     ${WHITE}.K#f${RED}              iWW;    L#D.    E###D.     EK:   ,WK. L#D.    E###D.     
    t#E    ${WHITE}:W#i${RED}              L##Lffi:K#Wfff;  E#jG#W;    E#t  i#D :K#Wfff;  E#jG#W;    
    t#E   ${WHITE};##Dfff.${RED}          tLLG##L i##WLLLLt E#t t##f   E#t j#f  i##WLLLLt E#t t##f   
    t#E   ${WHITE};##${BLACK}Lt${WHITE}##,${RED}            ,W#i   .E#L     E#t  :K#E: E#tL#i    .E#L     E#t  :K#E: 
    t#E    ${WHITE}:W#;##,${RED}           j#E.      f#E:   E#KDDDD###iE#WW,       f#E:   E#KDDDD###i
    t#E     ${WHITE}.E###,${RED}         .D#j         ,WW;  E#f,t#Wi,,,E#K:         ,WW;  E#f,t#Wi,,,
    t#E       ${WHITE}G##,${RED}        ,WK,           .D#; E#t  ;#W:  ED.           .D#; E#t  ;#W:  
     fE        ${WHITE}f#,${RED}        EG.              tt DWi   ,KK: t               tt DWi   ,KK: 
      :         ${WHITE}t:${RED}        ,                                                            
    ${NC}
      ╔═══════════════════════════════════════════════════════════════════════════╗
      ║  ${RED}Name:${GREY} T6 Server Installer${NC}                                                ║
      ║  ${YELLOW}Version:${GREY} 2.1.0${NC}                                                           ║
      ║  ${PURPLE}Author:${GREY} Sterbweise${NC}                                                       ║
      ║  ${GREEN}Last Updated:${GREY} 21/08/2024${NC}                                                 ║
      ╠═══════════════════════════════════════════════════════════════════════════╣
      ║                       ${LIGHT_BLUE}\e]8;;https://github.com/Sterbweise\aGithub\e]8;;\a${NC} | ${RED}\e]8;;https://youtube.com/@Sterbweise\aYoutube\e]8;;\a${NC} | ${ORANGE}\e]8;;https://plutonium.pw\aPlutonium\e]8;;\a${NC}                        ║
      ╚═══════════════════════════════════════════════════════════════════════════╝\n\n"
}