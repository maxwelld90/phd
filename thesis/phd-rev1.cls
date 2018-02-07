% David's PhD Thesis LaTeX Template Class
% Updated 2017-03-07

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{phd}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass[11pt,a4paper]{report}

% Package includes
\RequirePackage[quiet]{fontspec}
\usepackage{url}
\usepackage{abstract}
\usepackage[usenames,dvipsnames]{color}
\usepackage{epsfig}
\usepackage{epstopdf}
\usepackage{colortbl}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{ifthen}
\usepackage{tabularx}
\usepackage{tabulary}
\usepackage{subfigure}
\usepackage{natbib}
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



% Need to fix this for other pages, too. After the first page, it doesn't show.

% Table Columns
\newcolumntype{D}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{L}[1]{>{\arraybackslash}p{#1}}

% Drawing test
\usepackage{tikz}
\usepackage{varwidth}

%\usepackage{showframe}

\definecolor{dmax_lightblue}{HTML}{0072C6}
\definecolor{dmax_darkblue}{HTML}{00243D}

% Table of Contents Font and Spacing Definitions
\contentsmargin[1cm]{0cm}
\titlecontents{part}[0em]{\vskip 6pt\Large\headerfont}
{\thecontentslabel\enspace}
{\hspace{0pt}}
{ \hfill\contentspage}[\vskip 0pt]

\titlecontents{chapter}[0em]{\vskip 6pt\large\headerfont}
{\thecontentslabel\enspace\color{white}\colorbox{dmax_lightblue}}
{\hspace{1.05em}}
{ \hfill\contentspage}[\vskip 0pt]

\titlecontents{section}[1em]{\large\subtitlefont}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{subsection}[2.7em]{\large\subtitlefont}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{figure}[0em]{\vskip 6pt\large\subtitlefont}
{\thecontentslabel\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{table}[0em]{\vskip 6pt\large\subtitlefont}
{\thecontentslabel\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\DeclareFloatFont{lol}{\subtitlefont}% "scriptsize" is defined by floatrow, "tiny" not
\floatsetup[table]{font=lol}
\floatsetup[table]{capposition=top}

\usepackage{ifpdf}
\ifpdf
\usepackage[pdftex]{graphicx}
\else
\usepackage{graphicx}
\fi

% TOC depth settings -- comment out for defaults
%\setcounter{tocdepth}{3}
%\setcounter{secnumdepth}{3}

% Additional commands/environments
\newcommand{\todo}[1]{\textcolor{red}{#1}}
\newcommand{\highlight}[1]{\hl{#1}}
\newenvironment{bottompar}{\par\vspace*{\fill}}{\clearpage}

% Page dimensions
\setlength{\parindent}{0pt}
\setlength{\parskip}{11pt plus 2pt}
\addtolength\textwidth{1.0in}
\addtolength\oddsidemargin{-0.50in}
\addtolength\textheight{1.0in}
\addtolength\topmargin{-0.5in}

% Fonts
\setmainfont{Palatino}
\newfontfamily\headerfont[Path=./fonts/]{fs-demi.ttf}
\newfontfamily\subtitlefont[Path=./fonts/, ItalicFont=*italic, BoldFont=*bold]{fs-book.ttf}
\newfontfamily\subtitleitalicfont[Path=./fonts/]{fs-bookitalic.ttf}

% Captions
%\captionsetup[figure]{font={\headerfont},name={Figure},labelsep=period}
\DeclareCaptionFont{xipt}{\large\subtitlefont}
\usepackage[font={xipt,stretch=1.25},labelfont=bf]{caption}

% Front page matter
\renewcommand\maketitle{\begin{titlepage}%
\let\footnotesize\small
\let\footnoterule\relax
\let\footnote \thanks

\includegraphics[scale=1.1]{chapters/ch0-preamble/glasgow_logo}
\vskip 8em
%{\singlespacing\headerfont\fontsize{10.5mm}{12mm}\selectfont\@title\par}
\begin{tikzpicture}[remember picture, overlay, anchor=west]
    \node[fill=dmax_lightblue, anchor=north west, inner sep=4mm]
    at ([yshift=-94mm, xshift=-108.45mm] current page.north) {
        {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10.5mm}{12mm}\selectfont\@title\par\end{varwidth}}
    };
\end{tikzpicture}
\vskip 18mm
{\headerfont\huge\@author\par}
\vskip 0.5cm
{\Large\onehalfspacing School of Computing Science\\College of Science and Engineering\\University of Glasgow\\Scotland\par}
\vskip 2cm
{\LARGE A thesis submitted for the degree of\\\textbf{\emph{Doctor of Philosophy (PhD)}}\par}
\begin{bottompar}
{\singlespacing\Large\@date\hfill\textcopyright~David Maxwell}
\end{bottompar}

\vfill
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

\renewcommand{\absnamepos}{flushleft}
\setlength{\absleftindent}{0pt}
\setlength{\absrightindent}{0pt}
\renewcommand{\abstractname}{{\LARGE\headerfont Abstract}}

% \renewcommand{\abstractname}{{\LARGE\headerfont Abstract}
%
%     \begin{tikzpicture}[remember picture, overlay, anchor=west]
%         \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
%         at ([yshift=-47mm,xshift=-108.45mm] current page.north) {
%             {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\LARGE Abstract\par\end{varwidth}}
%         };
%     \end{tikzpicture}
% }

\renewcommand{\contentsname}{
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
        at ([yshift=-47mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont Table of Contents\par\end{varwidth}}
        };
    \end{tikzpicture}
}

\renewcommand{\listfigurename}{
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
        at ([yshift=-47mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont List of Figures\par\end{varwidth}}
        };
    \end{tikzpicture}
}

\renewcommand{\listtablename}{
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
        at ([yshift=-47mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont List of Tables\par\end{varwidth}}
        };
    \end{tikzpicture}
}


\renewcommand{\@makechapterhead}[1]{
    \vspace*{30mm}
    {\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont\@chapapp~\thechapter\par}
    {
    
\begin{tikzpicture}[remember picture, overlay, anchor=west]
    \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
    at ([yshift=-84mm, xshift=-107.45mm] current page.north) {
        {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont#1\par\end{varwidth}}
    };
\end{tikzpicture}
    \vskip 15mm
    }
}

%\titleformat*{\section}{\Large\headerfont}
%\titleformat*{\subsection}{\large\headerfont}
%\titleformat*{\subsubsection}{\large\headerfont}

% \titleformat{\section}
% {\color{black}\normalfont\Large\bfseries}
% {}{1em}{{\color{dmax_lightblue}\rule{0.35cm}{0.35cm}}\quad}

\titleformat{\section}{\normalfont\scshape}{\Large\headerfont\thesection}{6pt}{\Large\headerfont\color{white}\colorbox{dmax_lightblue}}

\titleformat{\subsection}{\normalfont\scshape}{\large\headerfont\thesubsection}{6pt}{\large\headerfont\color{white}\colorbox{dmax_lightblue}}

\titleformat{\subsubsection}{\normalfont\scshape}{\large\headerfont\thesubsubsection}{6pt}{\large\headerfont\color{white}\colorbox{dmax_lightblue}}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    
    \thispagestyle{empty}
    
    % Part~\thepart\par
    % #1\par
    % {\subtitleitalicfont\linespread{1.25}\huge#2\par}
    
    {\begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[anchor=north west]
        at ([yshift=-75mm,xshift=-105.45mm] current page.north) {
            {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont Part~\thepart\par\end{varwidth}}
        };
        
        \node[fill=dmax_darkblue, anchor=north west, inner sep=4mm]
        at ([yshift=-84mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{12mm}{12mm}\selectfont#1\par\end{varwidth}}
        };
        
        \node[anchor=north west]
        at ([yshift=-134mm,xshift=-105.45mm] current page.north) {
            {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\linespread{1.25}\huge\subtitlefont \emph{#2}\par\end{varwidth}}
        };
    \end{tikzpicture}}
    
    \clearpage

\def\appendicestitle{
    \clearpage
    \phantomsection
    \addcontentsline{toc}{part}{Appendices}
    \thispagestyle{empty}
    
    % Part~\thepart\par
    % #1\par
    % {\subtitleitalicfont\linespread{1.25}\huge#2\par}
    
    {\begin{tikzpicture}[remember picture, overlay, anchor=west]
        % \node[anchor=north west]
        % at ([yshift=-75mm,xshift=-105.45mm] current page.north) {
        %     {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont Part Something\par\end{varwidth}}
        % };
        
        \node[fill=dmax_darkblue, anchor=north west, inner sep=4mm]
        at ([yshift=-84mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{12mm}{12mm}\selectfont Appendices\par\end{varwidth}}
        };
        
        % \node[anchor=north west]
        % at ([yshift=-134mm,xshift=-105.45mm] current page.north) {
        %     {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\linespread{1.25}\huge\subtitlefont \emph{Remove me}\par\end{varwidth}}
        % };
    \end{tikzpicture}}
    
    \clearpage
}
    
\def\tableofcontents{\@restonecolfalse
  \if@twocolumn\@restonecoltrue\onecolumn\fi
  \clearpage
  \begin{center}   
        \MakeUppercase{\contentsname}
  \end{center}
  {\ssp\@starttoc{toc}}\if@restonecol\twocolumn\fi}
    
    
    
    
  % \reset@font
  % \parindent \z@
  % \vspace*{10\p@}%
  % \hbox{%
  %   \vbox{%
  %     \hsize=7mm%
  %     \begin{tabular}{@{}p{7mm}@{}}
  %       \makebox[7mm]{\scshape\strut\small\partname}\\
  %       \makebox[7mm]{\cellcolor{black}\Huge\color{white}\bfseries\strut\thepart\rule[-4cm]{0pt}{4cm}}%
  %     \end{tabular}%
  %     \makebox(0,0){\put(-10,-100){\fbox{\phantom{\rule[-4cm]{7mm}{4cm}}}}}
  %     }%
  %   \kern-2pt
  %   \vbox to 0pt{%
  %      \tabular[t]{@{}p{1cm}p{\dimexpr\hsize-2.1cm}@{}}\hline
  %         & \Huge\itshape\rule{0pt}{1.5\ht\strutbox}#1#2\endtabular}%
  %   }%
  % \cleardoublepage
%  \vskip 100\p@
}

% \renewenvironment{part}[1][]{%
%     \par
%     \vskip 4em
%     \noindent
%     {\headerfont\LARGE Part \thepart}
%     \vskip 1mm
%     {\headerfont\Huge#1}
%     \vskip 0.2cm
%     \noindent}
%     {}

\newenvironment{dmaxenv}[1][]
    {\pagestyle{empty}
    
    \ifx&#1&%
       \vspace*{0mm}
    \else
        \begin{tikzpicture}[remember picture, overlay, anchor=west]
            \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
            at ([yshift=-60mm,xshift=-108.45mm] current page.north) {
                {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\LARGE#1\par\end{varwidth}}
            };
        \end{tikzpicture}
    \fi
    

    
    \Large
    \onehalfspacing
    \vspace{10em}
    }
    { 
    \clearpage
    \pagestyle{plain}
    }

\renewcommand{\bibname}{
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
        at ([yshift=-47mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10mm}{10mm}\selectfont Bibliography\par\end{varwidth}}
        };
    \end{tikzpicture}
}