# Function to display the showLogo
# This function prints a stylized ASCII art showLogo for the T6 Server Installer
showLogo() {
    stty igncr
    clear
    printf "${COLORS[RED]}


                                   .        ,;                            ,;           
                ${COLORS[WHITE]}j,${COLORS[RED]}                ;W      f#i j.                        f#i j.         
 GEEEEEEEL     ${COLORS[WHITE]}L#,${COLORS[RED]}               f#E    .E#t  EW,                     .E#t  EW,        
 ,;;L#K;;.    ${COLORS[WHITE]}D#D${COLORS[RED]}              .E#f    i#W,   E##j       t      .DD. i#W,   E##j       
    t#E     ${COLORS[WHITE]}.K#f${COLORS[RED]}              iWW;    L#D.    E###D.     EK:   ,WK. L#D.    E###D.     
    t#E    ${COLORS[WHITE]}:W#i${COLORS[RED]}              L##Lffi:K#Wfff;  E#jG#W;    E#t  i#D :K#Wfff;  E#jG#W;    
    t#E   ${COLORS[WHITE]};##Dfff.${COLORS[RED]}          tLLG##L i##WLLLLt E#t t##f   E#t j#f  i##WLLLLt E#t t##f   
    t#E   ${COLORS[WHITE]};##${COLORS[BLACK]}Lt${COLORS[WHITE]}##,${COLORS[RED]}            ,W#i   .E#L     E#t  :K#E: E#tL#i    .E#L     E#t  :K#E: 
    t#E    ${COLORS[WHITE]}:W#;##,${COLORS[RED]}           j#E.      f#E:   E#KDDDD###iE#WW,       f#E:   E#KDDDD###i
    t#E     ${COLORS[WHITE]}.E###,${COLORS[RED]}         .D#j         ,WW;  E#f,t#Wi,,,E#K:         ,WW;  E#f,t#Wi,,,
    t#E       ${COLORS[WHITE]}G##,${COLORS[RED]}        ,WK,           .D#; E#t  ;#W:  ED.           .D#; E#t  ;#W:  
     fE        ${COLORS[WHITE]}f#,${COLORS[RED]}        EG.              tt DWi   ,KK: t               tt DWi   ,KK: 
      :         ${COLORS[WHITE]}t:${COLORS[RED]}        ,                                                            
    ${COLORS[RESET]}
      ╔═══════════════════════════════════════════════════════════════════════════╗
      ║  ${COLORS[RED]}Name:${COLORS[GREY]} T6 Server Installer${COLORS[RESET]}                                                ║
      ║  ${COLORS[YELLOW]}Version:${COLORS[GREY]} 3.1.1${COLORS[RESET]}                                                           ║
      ║  ${COLORS[PURPLE]}Author:${COLORS[GREY]} Sterbweise${COLORS[RESET]}                                                       ║
      ║  ${COLORS[GREEN]}Last Updated:${COLORS[GREY]} 07/12/2024${COLORS[RESET]}                                                 ║
      ╠═══════════════════════════════════════════════════════════════════════════╣
      ║                       ${COLORS[LIGHT_BLUE]}\e]8;;https://github.com/Sterbweise\aGithub\e]8;;\a${COLORS[RESET]} | ${COLORS[RED]}\e]8;;https://youtube.com/@Sterbweise\aYoutube\e]8;;\a${COLORS[RESET]} | ${COLORS[ORANGE]}\e]8;;https://plutonium.pw\aPlutonium\e]8;;\a${COLORS[RESET]}                        ║
      ╚═══════════════════════════════════════════════════════════════════════════╝\n\n"
}