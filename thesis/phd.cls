% =============================================================================
% phd.cls
%
% David's PhD Thesis template, hacked together by the man himself.
% More an exercise to improve my understanding of the LaTeX typesetting system.
% But hey, the thesis needs to stand out (content AND presentation)...
%
% So, why not?
% Provides the phd documentclass.
%
% Author: David Maxwell
% Date: 2017-10-26
%
%
% =============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{phd}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass[12pt,a4paper,twoside,openright]{report}

% Package includes
\RequirePackage[quiet]{fontspec}
\usepackage[bindingoffset=1.5cm,top=2.8cm,bottom=2.8cm,left=1.2cm,right=1.5cm,footskip=1.3cm]{geometry}
\usepackage{url}
\usepackage{abstract}
\usepackage[usenames,dvipsnames,table]{xcolor}
\usepackage{epsfig}
\usepackage{epstopdf}
\usepackage{colortbl}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{ifthen}
\usepackage{tabularx}
\usepackage{tabulary}
\usepackage{subfigure}
\usepackage[semicolon]{natbib}
\usepackage{setspace}
\usepackage{soul}
\usepackage{hyperref}
\usepackage{wrapfig}
\usepackage{longtable}
\usepackage{pdfpages}
\usepackage{caption}
\usepackage{mathpazo}
\usepackage{titlesec}
\usepackage{titletoc}
\usepackage{attrib}
\usepackage{floatrow}
\usepackage{ifpdf}
\usepackage{tikz}
\usepackage{varwidth}
\usepackage{etoolbox}
\usepackage{fancyhdr}
\usepackage{lmodern}
\usepackage{amssymb}
\usepackage{bibentry}
\usepackage{emptypage} % Together with report openright, blanks the left page before a new chapter starts.
\usepackage[nopostdot,acronym,savewrites,style=superborder]{glossaries}
\usepackage[most]{tcolorbox}
\usepackage{metalogo}
\usepackage{pxfonts}
\usepackage{fontspec}

\setlength{\parindent}{0pt}  % Removes the indent at the start of a paragraph (I think it's hella ugly, mate)
\renewcommand{\baselinestretch}{1.5}  % Compulsory 1 1/2 line spacing
\setlength{\parskip}{12pt plus 5pt}  % Add some spacing at the end of a paragraph (compensating for no indentation)

% Switch to square bullets. I think they look nicer.
\renewcommand\labelitemi{\tiny$\blacksquare$}

% Additional commands/environments
\newcommand{\todo}[1]{\textcolor{red}{#1}}  % Todo red text
\newcommand{\highlight}[1]{\hl{#1}}  % Highlight with colour
\newenvironment{bottompar}{\par\vspace*{\fill}}{\clearpage}  % Forces content in environment to the bottom of the page.
\newcolumntype{D}[1]{>{\centering\arraybackslash}p{#1}}  % Centred table column (variable width)
\newcolumntype{L}[1]{>{\arraybackslash}p{#1}}  % Left-align table column (variable width)

% Import relevant graphics package depending on compilation approach
\ifpdf
\usepackage[pdftex]{graphicx}
\else
\usepackage{graphicx}
\fi

% Custom command to allow pages to start on the left.
% Removes page styling for the blank page that is inserted.
% This is now redundant; kept in case it is required eventually.
\newcommand*\cleartoleftpage{%
  \clearpage
  \ifodd\value{page}\hbox{}\thispagestyle{empty}\newpage\fi
}

% TOC depth settings -- as per submission guidelines.
\setcounter{tocdepth}{3}
\setcounter{secnumdepth}{3}

% Define colour styles to fit "my" colours
\definecolor{dmax_lightlightblue}{HTML}{B3D5EE}
\definecolor{dmax_lightblue}{HTML}{0072C6}
\definecolor{dmax_darkblue}{HTML}{00243D}
\definecolor{dmax_red}{HTML}{89171F}
\definecolor{dmax_green}{HTML}{377A31}

% "Search" Colours
\definecolor{search_blue}{HTML}{567CBE}
\definecolor{search_red}{HTML}{E43628}
\definecolor{search_yellow}{HTML}{F7BE01}
\definecolor{search_green}{HTML}{2F9F42}

% Table line width
\setlength\arrayrulewidth{1pt}

% The "Search" Logotype
\newcommand{\searchlogo}{{\headerfont\color{search_blue}S\color{search_red}e\color{search_yellow}a\color{search_blue}r\color{search_green}c\color{search_red}h}}

% The "Treconomics" Logotype
\newcommand{\treconomics}{{\headerfont\color{dmax_darkblue}TREConomics}}

% The "SimIIR" Logotype
\newcommand{\simiir}{{\headerfont\color{dmax_darkblue}SimIIR}}

% Blue boxes!
\setlength\fboxsep{2mm} % Applies padding to the blue boxes.
\newcommand{\bluebox}[1]{\colorbox{dmax_lightblue}{\color{white}\metafont#1}}
\newcommand{\darkbluebox}[1]{\colorbox{dmax_darkblue}{\color{white}\metafont#1}}
\newcommand{\blueboxbold}[1]{\colorbox{dmax_lightblue}{\color{white}\headerfont#1}}
\newcommand{\darkblueboxbold}[1]{\colorbox{dmax_darkblue}{\color{white}\headerfont#1}}
\newcommand{\blueboxheader}[1]{\noindent\blueboxbold{#1}}

% Set fonts -- main narrative font to Palatino (fancy serif) and FoundrySterling for the meta stuff.
% Palatino is set as the math font by including package pxfonts.
\setmainfont{Palatino}
\newfontfamily\headerfont[Path=./fonts/]{fs-demi.ttf}
\newfontfamily\metafont[Path=./fonts/, ItalicFont=*italic, BoldFont=*bold]{fs-book.ttf}
\setmonofont{inconsolata}[Scale=MatchLowercase]

% % Set header/footer content -- create a phdpagestyle style
\fancypagestyle{phdpagestyle}{
    \fancyhf{}
    \fancyfoot[C]{\normalsize\metafont\thepage}
    \fancyhead[EL]{\metafont\nouppercase{\rightmark}}  % Why does the title reappear in the TOC?
    \fancyhead[OR]{\metafont\nouppercase{\rightmark}}  % Why does the title reappear in the TOC?
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\setlength{\headheight}{15pt}

% Apply the phdpagestyle style to all pages
\pagestyle{phdpagestyle}
\patchcmd{\chapter}{plain}{phdpagestyle}{}{}  % Override the first page of a chapter style (may be replaced)

% Remove the period after the section number in the header (looks nicer)
\renewcommand\sectionmark[1]{\markright{\thesection~\textbf{#1}}}

% Set up the bibliography so that complete entries can be dumped in the main narrative.
% This is achieved using the \bibitem{} command.
\nobibliography*
\renewcommand\bibentry[1]{\nocite{#1}{\frenchspacing
     \@nameuse{BR@r@#1\@extra@b@citeb}}}

% Set the table font
\DeclareFloatFont{tablefont}{\metafont}% "scriptsize" is defined by floatrow, "tiny" not
\floatsetup[table]{font=tablefont}
\floatsetup[table]{capposition=top}

% Captions -- use the metafont for caption descriptions, and set the line spacing as appropriate.
%\captionsetup[figure]{font={\headerfont},name={Figure},labelsep=period}
\DeclareCaptionFont{captionfont}{\metafont}
\usepackage[font={captionfont,stretch=1.5},labelfont=bf]{caption}

% Left-align captions, and change the way in which caption text is displayed (e.g. Figure x in blue box).
\DeclareCaptionFormat{cancaption}{\blueboxbold{#1}\hspace*{2mm}#3\par} % Normal format actually
\captionsetup{format=cancaption}

% Command for URLs (last accessed)
\newcommand{\urlaccessed}[1]{~\colorbox{dmax_lightlightblue}{\color{dmax_darkblue}\metafont{\textbf{LA}~\emph{#1}}}}

%%%%%%%%%%
%%% Table of Contents Styling
%%%%%%%%%%

% Adds extra room for the page numbers on the right hand side to fit.
\renewcommand{\contentspage}[1][\thecontentspage]{\hb@xt@\@pnumwidth{#1\hfil}\hspace*{-\@pnumwidth}}
\renewcommand{\@pnumwidth}{3em}

%\contentsmargin[-2cm]{0cm}
\titlecontents{part}[0em]{\Large\normalfont\headerfont\vspace*{-1mm}}
{\thecontentslabel\enspace}
{\hspace{0pt}}
{\hfill\contentspage}[\vskip 0pt]

\titlecontents{chapter}[0em]{\vskip 0pt\large\normalfont\headerfont\vspace*{-1mm}}
{\thecontentslabel\enspace\color{white}\colorbox{dmax_lightblue}}
{\hspace{0pt}}
{\hfill\contentspage}[\vskip 0pt]

\titlecontents{section}[1.35em]{\large\metafont\vspace*{-1mm}}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{subsection}[2.7em]{\large\metafont\vspace*{-1mm}}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{subsubsection}[4.05em]{\large\metafont\vspace*{-1mm}}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{figure}[0em]{\vskip 0pt\large\metafont\vspace*{-1mm}}
{\blueboxbold{\thecontentslabel}\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{table}[0em]{\vskip 0pt\large\metafont\vspace*{-1mm}}
{\blueboxbold{\thecontentslabel}\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

% Set the widths of the glossary/acronyms page
\setlength{\glsdescwidth}{\dimexpr\linewidth-17\tabcolsep}

% Alter the \tableofcontents command to prevent calling \contentsname so much -- it screws up the formatting.
\renewcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    }

% Same again for \listoffigures
\renewcommand\listoffigures{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listfigurename}%
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    }

% Same again for \listoftables
\renewcommand\listoftables{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listtablename}%
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    }

% Set a new style for presenting the initial abbreviation (italicised)
\newacronymstyle{italicise-long-short}
{%
  \GlsUseAcrEntryDispStyle{long-short}%
}
{%
  \GlsUseAcrStyleDefs{long-short}%
  \renewcommand*{\genacrfullformat}[2]{%
   \emph{\glsentrylong{##1}##2}\space
   \emph{(\glsentryshort{##1})}%
  }%
  \renewcommand*{\Genacrfullformat}[2]{%
   \emph{\Glsentrylong{##1}##2}\space
   \emph{(\glsentryshort{##1})}%
  }%
  \renewcommand*{\genplacrfullformat}[2]{%
   \emph{\glsentrylongpl{##1}##2}\space
   \emph{(\glsentryshortpl{##1})}%
  }%
  \renewcommand*{\Genplacrfullformat}[2]{%
   \emph{\Glsentrylongpl{##1}##2}\space
   \emph{(\glsentryshortpl{##1})}%
  }%
}

%%%%%%%%%%
%%% Header Restylying
%%%%%%%%%%

% Update "Table of Contents" to reflect custom styling.
\renewcommand{\contentsname}{
    \protect\toctitle{Table of Contents}
}

% Update "List of Figures" to reflect custom styling.
\renewcommand{\listfigurename}{
    \protect\toctitle{List of Figures}
    \vspace*{4mm}
}

% Update "List of Tables" to reflect custom styling.
\renewcommand{\listtablename}{
    \protect\toctitle{List of Tables}
    \vspace*{4mm}
}

% Update "List of Abbreviations" to reflect custom styling.
\renewcommand{\acronymname}{
    Abbreviations Used
}

% % Update the "Glossary" section header to use custom styling.
\renewcommand{\glossaryname}{
    Glossary of Terms
}

% Renew the command that creates the relevant glossary section, and add a header.
\renewcommand{\glossarysection}[2][]{
    \cleardoublepage
    \protect\toctitle{#1}
    
    \vspace*{52mm}
    
    \ifthenelse{\equal{#1}{\acronymname}}{\normalfont\selectfont\large For abbreviations complete with a \emph{see} reference, refer to the corresponding Glossary entry.\vspace*{7mm}}{\vspace*{8mm}}
}

% Update the bibliography title.
\renewcommand{\bibname}{
    \protect\toctitle{Bibliography}
    \markboth{}{}
    \pagestyle{plain}
}

%%%%%%%%%%
%%% Title/Preamble/Part Page Definitions
%%%%%%%%%%

% Define a command that produces a title for TOC pages and the bibliography.
\newcommand{\toctitle}[1]{
    \tikz[remember picture, overlay, anchor=west] {
        %\draw[fill=dmax_lightblue,draw=none] (-2.7,-30.8) rectangle ++(0.2,100.3);  % Blue line
        
        %\node[fill=dmax_lightblue, anchor=north west, inner xsep=3mm, inner ysep=depth("y")+3mm] at
        \node[fill=dmax_lightblue, anchor=north west, inner ysep=4mm, inner xsep=4mm, minimum height=18mm, minimum width=1mm] at  ([yshift=-67mm,xshift=-110.5mm] current page.north) { {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\normalfont\headerfont\fontsize{10mm}{10mm}\selectfont #1\end{varwidth}}}}}

% Redefining the titlepage command
\renewcommand\maketitle{\begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \let\footnote\thanks
    
    \noindent\includegraphics[scale=1.1]{figures/ch0-glasgow_logo.pdf}
    \vskip 8em
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        %\draw[fill=dmax_lightblue,draw=none] (-2.7,-19.2) rectangle ++(0.2,30.3); % Blue line
        
        \node[fill=dmax_lightblue, anchor=north west, inner sep=5mm]
        at ([yshift=-98mm, xshift=-110.75mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10.5mm}{12mm}\selectfont\noindent\@title\par\end{varwidth}}
        };
    \end{tikzpicture}
    \vskip 1.6cm
    {\headerfont\LARGE\noindent\@author\par}
    \vskip 0.4cm
    {\large\onehalfspacing\noindent School of Computing Science\\College of Science and Engineering\\University of Glasgow\\Scotland~\includegraphics[height=\fontcharht\font`\d]{figures/ch0-saltire.pdf}\par}
    \vskip 1cm
    {\Large\singlespacing\noindent A thesis submitted for the degree of\\\textbf{\emph{Doctor of Philosophy (PhD)}}\par}
    \begin{bottompar}
    {\singlespacing\large\noindent\textcopyright~David Maxwell}
    \end{bottompar}

    \vfill
    \cleardoublepage
    \end{titlepage}%
    \setcounter{footnote}{0}%
    \global\let\thanks\relax
    \global\let\maketitle\relax
    \global\let\@thanks\@empty
    \global\let\@author\@empty
    \global\let\@date\@empty
    \global\let\@title\@empty
    \global\let\title\relax
    \global\let\author\relax
    \global\let\date\relax
    \global\let\and\relax
}

% The preamble environment
\newenvironment{preamble}[1][]
    {\pagestyle{phdpagestyle}
    
    \ifx&#1&%
       \vspace*{0mm}
    \else
        \begin{tikzpicture}[remember picture, overlay, anchor=west]
            %\draw[fill=dmax_lightblue,draw=none] (-2.7,-30.8) rectangle ++(0.2,100.3);  % Blue line
            
            % \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm] at ([yshift=-67mm,xshift=-109.5mm] current page.north) { {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\normalfont\headerfont\fontsize{10mm}{10mm}\selectfont #1\end{varwidth}}}}
            
            \node[fill=dmax_lightblue, anchor=north west, inner ysep=4mm, inner xsep=4mm, minimum height=18mm, minimum width=1mm] at ([yshift=-67mm,xshift=-110.5mm] current page.north) {
                {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont\noindent#1\par\end{varwidth}}
            };
        \end{tikzpicture}
    \fi
    
    \large
    \vspace{10em}
    }
    {
    \cleardoublepage
    \pagestyle{plain}
}

% This command populates the page to the left before a part is introduced; although for now the tikz illustration is commented out.
\newcommand{\cleardoublepagebeforepart}[1][]{
    \clearpage
    
    \if@twoside
        \ifodd
            \c@page
        \else
            \hbox{}
            \thispagestyle{empty}
            
            % {\begin{tikzpicture}[remember picture, overlay, anchor=east]%
            %     \node[fill=dmax_darkblue, anchor=north west, inner xsep=1000mm, inner ysep=depth("y")+5mm]
            %     at ([yshift=-84mm,xshift=-109mm] current page.north) {
            %     {\hspace*{2.55cm}\color{dmax_darkblue}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{12mm}{12mm}\selectfont\raggedright\flushright#1\par\end{varwidth}}
            %     };
            % \end{tikzpicture}}
            
            \newpage
        
            \if@twocolumn
                \hbox{}
                \newpage
            \fi
        \fi
    \fi}

% Part introductory page
\renewcommand{\part}[3][] {
    \clearpage
    \ifodd\value{page}\hbox{}\thispagestyle{empty}\newpage\fi
    \cleardoublepagebeforepart[#1]
    \thispagestyle{empty}
    
    % This is because we've added some pages beforehand, which 
    \ifnum \thepage = 3
        \setcounter{page}{1}
    \fi
    
    \ifnum \c@secnumdepth >-2\relax
        \refstepcounter{part}%
        \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    
    {\begin{tikzpicture}[remember picture, overlay, anchor=east]%
        
        %\draw[fill=dmax_darkblue,draw=none] (-2.7,-26.4) rectangle ++(0.2,100.3);  % Blue line
        
        \node[anchor=north west]
        at ([yshift=-72.2mm,xshift=-80mm] current page.north) {
            {\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{8mm}{8mm}\selectfont Part~\thepart\par\end{varwidth}\hspace*{2.8cm}}
        };
        
        \node[fill=dmax_darkblue, anchor=north west, inner xsep=5mm, inner ysep=depth("y")+5mm]
        at ([yshift=-84mm,xshift=-109mm] current page.north) {
        {\hspace*{2.55cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{12mm}{12mm}\selectfont\raggedright#3\par\end{varwidth}}
        };
        
        \node[anchor=north west]
        at ([yshift=-138mm,xshift=-80mm] current page.north) {
            {\begin{varwidth}{\linewidth}\linespread{1.25}\huge\metafont\raggedright\emph{#2}\par\end{varwidth}}
        };
    \end{tikzpicture}}
    
    \clearpage
}

% Update the chapter header to use the custom styling.
\renewcommand{\@makechapterhead}[1]{
    \vspace*{50mm}
    %{\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont\@chapapp~\thechapter\par}
    {

\begin{tikzpicture}[remember picture, overlay, anchor=west]
    
    %\draw[fill=dmax_lightblue,draw=none] (-2.7,-22.8) rectangle ++(0.2,100.3);  % Blue line
    
    \node[anchor=north west]
    at ([yshift=-72mm,xshift=-80mm] current page.north) {
        {\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{8mm}{8mm}\selectfont \@chapapp~\thechapter\par\end{varwidth}\hspace*{2.8cm}}
    };
    
    %\node[fill=dmax_lightblue, anchor=north west, inner xsep=3mm, inner ysep=depth("y")+3mm]
    \node[fill=dmax_lightblue, anchor=north west, inner ysep=4mm, inner xsep=4mm, minimum height=18mm, minimum width=1mm]
    at ([yshift=-84mm, xshift=-110.5mm] current page.north) {
    {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.2}\headerfont\fontsize{11mm}{11mm}\selectfont#1\par\end{varwidth}}
    };
\end{tikzpicture}
    \vskip 30mm
    }
    \normalsize
}

% Section header
\titleformat{\section}{}{\Large\normalfont\headerfont\thesection}{6pt}{\Large\normalfont\headerfont\color{white}\colorbox{dmax_lightblue}}

% Subsection Header
\titleformat{\subsection}{}{\large\normalfont\headerfont\thesubsection}{6pt}{\large\normalfont\headerfont\color{white}\colorbox{dmax_lightblue}}

% Subsubsection Header
\titleformat{\subsubsection}{}{\large\normalfont\headerfont\thesubsubsection}{6pt}{\large\normalfont\headerfont\color{white}\colorbox{dmax_lightblue}}

% Add a page for separating out appendices
\def\appendicestitle{
    \clearpage
    \ifodd\value{page}\hbox{}\thispagestyle{empty}\newpage\fi
    \cleardoublepagebeforepart[Appendices]
    \thispagestyle{empty}
    \phantomsection
    \addcontentsline{toc}{part}{Appendices}
    \thispagestyle{empty}
    
    {\begin{tikzpicture}[remember picture, overlay, anchor=east]%
        
        %\draw[fill=dmax_darkblue,draw=none] (-2.7,-26.4) rectangle ++(0.2,100.3);  % Blue line
        
        %\node[anchor=north west]
        %at ([yshift=-72mm,xshift=-80mm] current page.north) {
        %    {\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{8mm}{8mm}\selectfont Part~\thepart\par\end{varwidth}\hspace*{2.8cm}}
        %};
        
        \node[fill=dmax_darkblue, anchor=north west, inner xsep=5mm, inner ysep=depth("y")+5mm]
        at ([yshift=-84mm,xshift=-109mm] current page.north) {
        {\hspace*{2.55cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{12mm}{12mm}\selectfont\raggedright\flushright Appendices\par\end{varwidth}}
        };
        
        \node[anchor=north west]
        at ([yshift=-138mm,xshift=-80mm] current page.north) {
            {\begin{varwidth}{\linewidth}\linespread{1.25}\huge\metafont\raggedright\emph{Included in the appendices for this thesis is a discussion of the SimIIR framework, and work that was undertaken to incorporate state and agency into the Complex Searcher Model.}\par\end{varwidth}}
        };
        
    \end{tikzpicture}}

    \clearpage
}

% Restyle the list of abbreviations and any glossary-related entry with my custom styling.
% i.e. apply the blue box to the item, and change the font for the description (and item name).
%\renewcommand{\glsnamefont}[1]{\large\headerfont\color{white}\colorbox{dmax_lightblue}{#1}}
%\renewcommand{\glossentrydesc}[1]{\large\metafont\glsdesc{#1}}

\renewcommand*{\glsclearpage}{\cleardoublepage}
\newcommand{\glossarysee}[1]{, \emph{see}~\colorbox{dmax_lightblue}{\color{white}\headerfont#1}}

% Creates a new glossary style for the thesis.
% Note the longtable width should equal 160mm across (roughly). Adjust as required.
\newglossarystyle{thesisglossary}{%
    \renewenvironment{theglossary}%
         {\renewcommand{\arraystretch}{1.4}\begin{longtable}{p{40mm}p{120mm}}}%
         {\end{longtable}}%
         
    \renewcommand*{\glossaryheader}{}%
    
    \renewcommand*{\glsgroupheading}[1]{\vspace{2.5mm}\darkblueboxbold{\Large{##1}}\\}%
    
    \renewcommand*{\glossaryentryfield}[5]{%
        \glstarget{##1}{\blueboxbold{\large##2}} & \onehalfspacing\large\normalfont##3\glspostdescription\space ##5\\}%
        
    \renewcommand*{\glsgroupskip}{ & \\}%
}

% Colour box for listing publications.
\newtcolorbox{publications_box}[2][]{%
    colback=dmax_lightblue!0!white,
    colframe=dmax_lightblue!100!black,
    fonttitle=\headerfont\large,
    fontupper=\noindent,
    title=#2,
    sharp corners,
    enhanced,
    toptitle=5pt,
    bottomtitle=5pt,
    left=5pt,
    right=5pt,
    frame hidden,
    borderline north={10mm}{0pt}{dmax_lightblue},
    borderline south={1mm}{0pt}{dmax_lightblue}
}

% Renew the attribution command for quotes. Easier to do it this way.
\renewcommand\attrib[1] {%
  \begingroup
    \at@init
    \nobreak\hfil\penalty50%
    \hskip\AttribMinSkip
    \vadjust{}\nobreak\hfil
    {\relax\blueboxbold{#1}}%
    \parfillskip\z@
    \nobreak
    \finalhyphendemerits0%
    \par
  \endgroup
}