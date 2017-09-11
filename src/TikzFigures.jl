module TikzFigures

using LaTeXStrings
using TikzPictures

export tsdiagram, opensystem, streamtube

function standard_preamble()
    return """
        \\usetikzlibrary{angles}
        \\usetikzlibrary{arrows}
        \\usetikzlibrary{calc}
        \\usetikzlibrary{intersections}
        \\usetikzlibrary{patterns}
        \\usetikzlibrary{positioning}
        \\usetikzlibrary{quotes}
        \\usetikzlibrary{decorations.markings}
        \\usepackage{pgfplots}
        \\usepgfplotslibrary{fillbetween}
        \\pgfplotsset{compat=newest}

        \\usepackage{bm}
        \\usepackage{siunitx}

        \\tikzset{bigarrow/.style={decoration={markings,
            mark=at position 1 with {\\arrow[scale= 1.5,>=stealth]{>}}
        },postaction={decorate}}}

        \\tikzset{sizearrow/.style={decoration={markings,
            mark=at position 0 with {\\arrow[scale=-0.8,>=stealth]{>}},
            mark=at position 1 with {\\arrow[scale= 0.8,>=stealth]{>}}
        },postaction={decorate}}}
        
        \\newcommand{\\microns}{\\si{\\um} }
        \\newcommand{\\vect}[1]{\\bm{#1}}
        \\newcommand{\\appr}[1]{{\\tilde{#1}}}
        \\newcommand{\\transpose}[1]{#1^\\mathrm{T}}
        \\newcommand{\\intd}{\\,\\mathrm{d}}
        \\newcommand{\\dd}{\\mathrm{d}}
        \\newcommand{\\diver}{\\mathrm{div}\\,}
        \\newcommand{\\grad}{\\mathrm{grad}\\,}
        \\newcommand{\\stab}[1]{\\tau_\\mathrm{\\textsc{#1}}}
        \\newcommand{\\ddt}[1]{\\frac{\\mathrm{d}#1}{\\mathrm{d}t}}
        \\newcommand{\\DDt}[1]{\\frac{\\mathrm{D}#1}{\\mathrm{D}t}}
        \\newcommand{\\re}{\\mathrm{Re}}
        \\newcommand{\\st}{\\mathrm{St}}
        \\newcommand{\\kn}{\\mathrm{Kn}}
        \\newcommand{\\vol}{\\mathcal{V}}
        \\newcommand{\\es}{\\mathrm{e \\rightarrow s}}
        \\newcommand{\\dS}{\\mathrm{d}S}
        \\newcommand{\\dSir}{\\mathrm{d}S_\\mathrm{irrev}}
        \\newcommand{\\ds}{\\mathrm{d}s}
        \\newcommand{\\dsir}{\\mathrm{d}s_\\mathrm{irrev}}
        \\newcommand{\\Pfa}{P_\\mathrm{fa}}
        \\newcommand{\\Pfr}{P_\\mathrm{fr}}
        """
end

isobar(T,s,s0=0,cp=1006) = T*exp((s-s0)/cp)

function tsdiagram(cp=1006, s2=0, s5=900, T2=287, T4is=500)
    T5 = isobar(T4is, s5, s2, cp)
    T7is = isobar(T2, s5, s2, cp)
    TikzPicture(L"""
    \begin{axis}[scale=2,
        ticks=none,
        axis lines=middle,
        axis x line=bottom,
        axis y line=left,
        xlabel={$s$},
        ylabel={$T$},
        clip=false,
        mark options={solid},
        ymin=\Tmin,
        xmin=\smin,
        x label style={at={(axis description cs:0.5,-0.02)},anchor=north},
        y label style={at={(axis description cs:-0.02,.5)},rotate=90,anchor=south}]

    \addplot[name path=p1,domain=-100:1000,thin] {\TA*\isobar(x)} node[above right] {$p_2$};
    \addplot[name path=p2,domain=-100:1000,thin] {\TBis*\isobar(x)} node[above] {$p_4$};
    \addplot[name path=it,domain=0:1000,thick,mark=*] coordinates {(\sA,\TA)(\sA,\TBis)}
        node[pos=0, below] {$2$}
        node[pos=1, above] {$4$};
    \addplot[name path=it,domain=0:1000,thick,mark=*] coordinates {(\sC,\TC)(\sC,\TDis)}
        node[pos=0, above] {$5$}
        node[pos=1, below] {$7$};

    \end{axis}
    """,options="scale=1", preamble=standard_preamble()*"""    
        \\def\\Tmin{$T2 - 200}
        \\def\\smin{$s2 - 400}
        \\def\\TA{$T2}
        \\def\\TBis{$T4is}
        \\def\\sA{$s2}
        \\def\\TC{$T5}
        \\def\\sC{$s5}
        \\def\\TDis{$T7is}
        \\def\\isobar(#1){exp((x-$s2)/$cp)}
    """)
end

function tsdiagram(cp, s2, s4, s5, s7, T2, T4is)
    T4 = isobar(T4is, s4, s2)
    T5 = isobar(T4is, s5, s2)
    T7is = isobar(T2, s5, s2)
    T7 = isobar(T2, s7, s2)
    TikzPicture(L"""
    \begin{axis}[scale=2,axis lines=middle,axis x line=bottom,axis y line=left,xlabel={$s$ (\si{\joule\per\kg\per\kelvin})}, ylabel={$T$ (\si{\kelvin})}, clip=false, mark options={solid}, ymin=\Tmin, xmin=\smin] %,xmin=0,xmax=1.1]

    %\coordinate (A) at (\sA,\Tit);
    %\coordinate (B) at (\sB,\Tit);

    \addplot[name path=p1,domain=0:1000,thin] {\TA*\isobar(x)} node[above right] {$p_2$};
    \addplot[name path=p2,domain=0:1000,thin] {\TBis*\isobar(x)} node[above] {$p_4$};
    \addplot[name path=it,domain=0:1000,thick,mark=*] coordinates {(\sA,\TA)(\sA,\TBis)}
        node[pos=0, below] {$2$}
        node[pos=1, above] {$4_\mathrm{is}$};
    \addplot[name path=it,domain=0:1000,thick,dashed,mark=*] coordinates {(\sA,\TA)(\sB,\TB)}
        node[pos=1, above] {$4$};
    \addplot[name path=it,domain=0:1000,thick,mark=*] coordinates {(\sC,\TC)(\sC,\TDis)}
        node[pos=0, above] {$5$}
        node[pos=1, below] {$7_\mathrm{is}$};
    \addplot[name path=it,domain=0:1000,thick,dashed,mark=*] coordinates {(\sC,\TC)(\sD,\TD)}
        node[pos=1, below] {$7$};
    
    \draw [very thin, dashed] (axis cs:\sA,\TA) -- (axis cs:{\sA-100},\TA);
    \draw [very thin, dashed] (axis cs:\sA,\TBis) -- (axis cs:{\sA-100},\TBis);
    \draw [<->,>=stealth,thin] (axis cs:\sA-100,\TBis) -- node[left] {$\Delta T_\mathrm{c,is}$} (axis cs:{\sA-100},\TA);
    
    \draw [very thin, dashed] (axis cs:\sA,\TA) -- (axis cs:{\sB+100},\TA);
    \draw [very thin, dashed] (axis cs:\sB,\TB) -- (axis cs:{\sB+100},\TB);
    \draw [<->,>=stealth,thin] (axis cs:\sB+100,\TB) -- node[right] {$\Delta T_\mathrm{c}$} (axis cs:{\sB+100},\TA);
    
    \draw [very thin, dashed] (axis cs:\sC,\TDis) -- (axis cs:{\sC-100},\TDis);
    \draw [very thin, dashed] (axis cs:\sC,\TC) -- (axis cs:{\sC-100},\TC);
    \draw [<->,>=stealth,thin] (axis cs:\sC-100,\TDis) -- node[left] {$\Delta T_\mathrm{t,is}$} (axis cs:{\sC-100},\TC);
    
    \draw [very thin, dashed] (axis cs:\sC,\TC) -- (axis cs:{\sD+100},\TC);
    \draw [very thin, dashed] (axis cs:\sD,\TD) -- (axis cs:{\sD+100},\TD);
    \draw [<->,>=stealth,thin] (axis cs:\sD+100,\TC) -- node[right] {$\Delta T_\mathrm{t}$} (axis cs:{\sD+100},\TD);

    \end{axis}
    """,options="scale=1", preamble=standard_preamble()*"""
        \\def\\Tmin{$T2 - 200}
        \\def\\smin{$s2 - 400}
        \\def\\TA{$T2}
        \\def\\TBis{$T4is}
        \\def\\TB{$T4}
        \\def\\sA{$s2}
        \\def\\sB{$s4}
        \\def\\TC{$T5}
        \\def\\sC{$s5}
        \\def\\sD{$s7}
        \\def\\TDis{$T7is}
        \\def\\TD{$T7}
        \\def\\isobar(#1){exp((x-$s2)/$cp)}
    """)
end

function opensystem()
    TikzPicture(L"""
        \def\xib{0.5}
        \def\xit{0.5}
        \def\xob{2.5}
        \def\xot{2.5}

        \def\dx{0.3}

        \def\xibp{\xib+1.2*\dx}
        \def\xitp{\xit+1.2*\dx}
        \def\xobp{\xob+1.2*\dx}
        \def\xotp{\xot+1.2*\dx}

        \def\xidmb{1.7}
        \def\xodmb{1.8}
        \def\xidmt{1.7}
        \def\xodmt{1.8}

        \coordinate (dmc) at ({(\xidmb+\xodmb+\xidmt+\xodmt)/4},{(botwall(\xidmb)+botwall(\xodmb)+topwall(\xidmt)+topwall(\xodmt))/4});

        \draw[name path=bottom,very thick] plot [domain=0:3.5] (\x,{botwall(\x)});
        \draw[name path=top,very thick] plot [domain=0:3.5] (\x,{topwall(\x)});

        \filldraw[fill=black, fill opacity=0.1,thin] plot [domain=\xib:\xob] (\x,{botwall(\x)}) -- (\xot, {topwall(\xot)}) node[above,opacity=1] {$b$} plot [domain=\xot:\xit] (\x,{topwall(\x)}) node[right,pos=0.5,opacity=1] {$2$} node[above,opacity=1] {$a$} -- (\xib, {botwall(\xib)}) node[right,pos=0.5,opacity=1] {$1$};

        \filldraw[fill=black, fill opacity=0.2,thin] plot [domain=\xibp:\xobp] (\x,{botwall(\x)}) -- (\xotp, {topwall(\xotp)}) node[above,opacity=1] {$b'$} plot [domain=\xotp:\xitp] (\x,{topwall(\x)}) node[above,opacity=1] {$a'$} -- (\xibp, {botwall(\xibp)});

        \filldraw[pattern=north east lines,thick]
        plot [domain=\xidmb:\xodmb] (\x,{botwall(\x)}) node[below] {$P_i$} -- (\xodmt, {topwall(\xodmt)})
        plot [domain=\xodmt:\xidmt] (\x,{topwall(\x)}) -- (\xidmb, {botwall(\xidmb)});

    """,
    options="""
        scale=3,
        declare function={  botwall(\\x) = -(\\x/3-3.5/6)^2;
				            topwall(\\x) = (\\x/3-3.5/6)^2+0.75;
        }""", preamble=standard_preamble())
end

function streamtube()
    TikzPicture(L"""
        \def\xib{0.5}
        \def\xit{0.4}
        \def\xob{2.5}
        \def\xot{2}

        \def\dx{0.3}

        \def\xibp{\xib+1.2*\dx}
        \def\xitp{\xit+\dx}
        \def\xobp{\xob+1.2*\dx}
        \def\xotp{\xot+\dx}

        \def\xidmb{1.7}
        \def\xodmb{1.8}
        \def\xidmt{1.3}
        \def\xodmt{1.4}

        \coordinate (dmc) at ({(\xidmb+\xodmb+\xidmt+\xodmt)/4},{(botwall(\xidmb)+botwall(\xodmb)+topwall(\xidmt)+topwall(\xodmt))/4});

        \draw[name path=bottom,very thick] plot [domain=0:3.5] (\x,{botwall(\x)});
        \draw[name path=top,very thick] plot [domain=0:3] (\x,{topwall(\x)});

        \filldraw[fill=black, fill opacity=0.1,thin] plot [domain=\xib:\xob] (\x,{botwall(\x)}) -- (\xot, {topwall(\xot)}) node[above,opacity=1] {$b$} plot [domain=\xot:\xit] (\x,{topwall(\x)}) node[right,pos=0.5,opacity=1] {$2$} node[above,opacity=1] {$a$} -- (\xib, {botwall(\xib)}) node[right,pos=0.5,opacity=1] {$1$};

        \filldraw[fill=black, fill opacity=0.2,thin] plot [domain=\xibp:\xobp] (\x,{botwall(\x)}) -- (\xotp, {topwall(\xotp)}) node[above,opacity=1] {$b'$} plot [domain=\xotp:\xitp] (\x,{topwall(\x)}) node[above,opacity=1] {$a'$} -- (\xibp, {botwall(\xibp)});

        \filldraw[pattern=north east lines,thick]
        plot [domain=\xidmb:\xodmb] (\x,{botwall(\x)}) node[below] {$\dd m$} -- (\xodmt, {topwall(\xodmt)}) node[right,pos=0.8] {j}
        plot [domain=\xodmt:\xidmt] (\x,{topwall(\x)}) -- (\xidmb, {botwall(\xidmb)}) node[left,pos=0.2] {i};

        \fill [black] (dmc) circle (0.025);
        \draw [bigarrow] (dmc) -- ++(0.3,0.3) node[above] {$\vect{a}$};
        \draw [bigarrow] (dmc) -- ++(0.2,0.1) node[below] {$\vect{\dd s}$};
    """,
    options="""
        scale=3,
        declare function={  botwall(\\x) = (\\x/3)^2;
				            topwall(\\x) = 1+2*(\\x/3)^2;
        }""", preamble=standard_preamble())
end

end # module
