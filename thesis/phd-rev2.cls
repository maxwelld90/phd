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
% Date: 2017-03-14
%
% Todo: Make the template work across two-page styles (i.e. odd and even pages)
%
% =============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{phd}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass[11pt,a4paper]{report}
% Add twoside above to switch to two-sided template, but it screws up formatting.
% Search Google for latex if even page to get information on how to work out what side you're on.
% The margins are too big in places -- why?

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
\usepackage{ifpdf}
\usepackage{tikz}
\usepackage{varwidth}
\usepackage{etoolbox}
\usepackage{fancyhdr}
\usepackage{lmodern}
\usepackage{amssymb}
\usepackage{bibentry}
\usepackage[nopostdot,acronym,style=super]{glossaries}

% \usepackage{enumitem}
%\usepackage{showframe}  % Uncomment to show frames/borders around pages

% Tweak the left margin for itemize lists.
% \setlist{leftmargin=20mm}

% Set up the bibliography so that complete entries can be dumped in the main narrative.
% This is achieved using the \bibitem{} command.
\nobibliography*
\renewcommand\bibentry[1]{\nocite{#1}{\frenchspacing
     \@nameuse{BR@r@#1\@extra@b@citeb}}}

% Import relevant graphics package depending on compilation approach
\ifpdf
\usepackage[pdftex]{graphicx}
\else
\usepackage{graphicx}
\fi

% Switch to square bullets. I think they look nicer.
\renewcommand\labelitemi{\tiny$\blacksquare$}

% Add a custom command to wrap things inside a blue box.
% Useful for things like items in a list, next to a description, for example.
\newcommand{\bluebox}[1]{\colorbox{dmax_lightblue}{\color{white}\metafont#1}}
\newcommand{\blueboxbold}[1]{\colorbox{dmax_lightblue}{\color{white}\headerfont#1}}

% TOC depth settings -- comment out for defaults (might need to tweak TOC presentation if these are changed)
%\setcounter{tocdepth}{3}
%\setcounter{secnumdepth}{3}

% Additional commands/environments
\newcommand{\todo}[1]{\textcolor{red}{#1}}  % Todo red text
\newcommand{\highlight}[1]{\hl{#1}}  % Highlight with colour
\newenvironment{bottompar}{\par\vspace*{\fill}}{\clearpage}  % Forces content in environment to the bottom of the page.
\newcolumntype{D}[1]{>{\centering\arraybackslash}p{#1}}  % Centred table column (variable width)
\newcolumntype{L}[1]{>{\arraybackslash}p{#1}}  % Left-align table column (variable width)

% Define colour styles for the thesis
\definecolor{dmax_lightblue}{HTML}{0072C6}
\definecolor{dmax_darkblue}{HTML}{00243D}

% Set the page dimensions (this must be done before setting the header/footer content!)
\setlength{\parindent}{0pt}
\setlength{\parskip}{11pt plus 2pt}
\addtolength\textwidth{1.0in}
\addtolength\oddsidemargin{-0.50in}
\addtolength\textheight{1.0in}
\addtolength\topmargin{-0.5in}

% % Set header/footer content -- create a phdpagestyle style
\fancypagestyle{phdpagestyle}{
    \fancyhf{}
    \fancyfoot[C]{\large\metafont\thepage}
    \fancyhead[EL]{\metafont\nouppercase{\rightmark}}  % Why does the title reappear in the TOC?
    \fancyhead[OR]{\metafont\nouppercase{\rightmark}}  % Why does the title reappear in the TOC?
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
\setlength{\headheight}{14pt}

% Apply the phdpagestyle style to all pages
\pagestyle{phdpagestyle}
\patchcmd{\chapter}{plain}{phdpagestyle}{}{}  % Override the first page of a chapter style (may be replaced)

% Remove the period after the section number in the header (looks nicer)
\renewcommand\sectionmark[1]{\markright{\thesection~\textbf{#1}}}

% Set fonts -- main narrative font to Palatino (fancy serif) and FoundrySterling for the meta stuff.
\setmainfont{Palatino}
\newfontfamily\headerfont[Path=./fonts/]{fs-demi.ttf}
\newfontfamily\metafont[Path=./fonts/, ItalicFont=*italic, BoldFont=*bold]{fs-book.ttf}

% Set the table font
\DeclareFloatFont{tablefont}{\metafont}% "scriptsize" is defined by floatrow, "tiny" not
\floatsetup[table]{font=tablefont}
\floatsetup[table]{capposition=top}

% Captions -- use the metafont for caption descriptions, and set the line spacing as appropriate.
%\captionsetup[figure]{font={\headerfont},name={Figure},labelsep=period}
\DeclareCaptionFont{captionfont}{\large\metafont}
\usepackage[font={captionfont,stretch=1.25},labelfont=bf]{caption}

% Front page matter
% Laying out the title page
\renewcommand\maketitle{\begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \let\footnote \thanks

    \includegraphics[scale=1.1]{figures/ch0-glasgow_logo.pdf}
    \vskip 8em
    \begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_lightblue, anchor=north west, inner sep=4mm]
        at ([yshift=-94mm, xshift=-108.45mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{10.5mm}{12mm}\selectfont\@title\par\end{varwidth}}
        };
    \end{tikzpicture}
    \vskip 18mm
    {\headerfont\huge\@author\par}
    \vskip 0.5cm
    {\Large\onehalfspacing School of Computing Science\\College of Science and Engineering\\University of Glasgow\\Scotland~\includegraphics[height=\fontcharht\font`\d]{figures/ch0-saltire.pdf}\par}
    \vskip 2cm
    {\LARGE A thesis submitted for the degree of\\\textbf{\emph{Doctor of Philosophy (PhD)}}\par}
    \begin{bottompar}
    {\singlespacing\Large\textcopyright~David Maxwell\hfill\@date}
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

\newenvironment{preamble}[1][]
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

% Table of Contents Font and Spacing Definitions
\contentsmargin[1cm]{0cm}
\titlecontents{part}[0em]{\vskip 6pt\Large\normalfont\headerfont}
{\thecontentslabel\enspace}
{\hspace{0pt}}
{ \hfill\contentspage}[\vskip 0pt]

\titlecontents{chapter}[0em]{\vskip 6pt\large\normalfont\headerfont}
{\thecontentslabel\enspace\color{white}\colorbox{dmax_lightblue}}
{\hspace{1.05em}}
{ \hfill\contentspage}[\vskip 0pt]

\titlecontents{section}[1em]{\large\metafont}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{subsection}[2.7em]{\large\metafont}
{\thecontentslabel\enspace}
{}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{figure}[0em]{\vskip 6pt\large\metafont}
{\thecontentslabel\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

\titlecontents{table}[0em]{\vskip 6pt\large\metafont}
{\thecontentslabel\enspace}
{\hspace{1.05em}}
{\titlerule*[1pc]{.}\quad\contentspage}[\vskip 0pt]

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

% Update "Table of Contents" to reflect custom styling.
\renewcommand{\contentsname}{
    \protect\toctitle{Table of Contents}
}

% Update "List of Figures" to reflect custom styling.
\renewcommand{\listfigurename}{
    \protect\toctitle{List of Figures}
}

% Update "List of Tables" to reflect custom styling.
\renewcommand{\listtablename}{
    \protect\toctitle{List of Tables}
}

% Update "List of Abbreviations" to reflect custom styling.
\renewcommand*{\acronymname}{
    \protect\toctitle{List of Abbreviations}
}

% Update the "Glossary" section header to use custom styling.
\renewcommand*{\glossaryname}{
    \protect\toctitle{Glossary}
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

\setacronymstyle{italicise-long-short}

% Restyle the list of abbreviations and any glossary-related entry with my custom styling.
% i.e. apply the blue box to the item, and change the font for the description (and item name).
\renewcommand{\glsnamefont}[1]{\large\headerfont\color{white}\colorbox{dmax_lightblue}{#1}}
\renewcommand{\glossentrydesc}[1]{\large\metafont\glsdesc{#1}}

% Set the widths of the glossary/acronyms page
\setlength{\glsdescwidth}{\dimexpr\linewidth-17\tabcolsep}

% Update the chapter header to use the custom styling.
\renewcommand{\@makechapterhead}[1]{
    \vspace*{30mm}
    {\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont\@chapapp~\thechapter\par}
    {

\begin{tikzpicture}[remember picture, overlay, anchor=west]
    \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm]
    at ([yshift=-84mm, xshift=-107.45mm] current page.north) {
        {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{10mm}{10mm}\selectfont#1\par\end{varwidth}}
    };
\end{tikzpicture}
    \vskip 30mm
    }
    \onehalfspacing
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
    \phantomsection
    \addcontentsline{toc}{part}{Appendices}
    \thispagestyle{empty}

    {\begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[fill=dmax_darkblue, anchor=north west, inner sep=4mm]
        at ([yshift=-84mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{12mm}{12mm}\selectfont Appendices\par\end{varwidth}}
        };
    \end{tikzpicture}}

    \clearpage
}

% Define a robust command that produces a title for TOC pages and the bibliography.
\DeclareRobustCommand{\toctitle}[1]{%
    \tikz[remember picture, overlay, anchor=west] { \node[fill=dmax_lightblue, anchor=north west, inner sep=3mm] at ([yshift=-47mm,xshift=-108.45mm] current page.north) { {\hspace*{2.9cm}\color{white}\begin{varwidth}{\linewidth}\singlespacing\normalfont\headerfont\fontsize{10mm}{10mm}\selectfont #1\end{varwidth}}}}}

% Update the bibliography title.
\renewcommand{\bibname}{
    \protect\toctitle{Bibliography}
    \markboth{}{}
    \pagestyle{plain}
}

% Part introductory page
\renewcommand{\part}[3][] {
    \clearpage
    
    \ifnum \c@secnumdepth >-2\relax
        \refstepcounter{part}%
        \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    
    \thispagestyle{empty}
    
    {\begin{tikzpicture}[remember picture, overlay, anchor=west]
        \node[anchor=north west]
        at ([yshift=-76mm,xshift=-105.45mm] current page.north) {
            {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\singlespacing\headerfont\fontsize{6mm}{6mm}\selectfont Part~\thepart\par\end{varwidth}}
        };

        \node[fill=dmax_darkblue, anchor=north west, inner sep=4mm]
        at ([yshift=-84mm,xshift=-108.45mm] current page.north) {
            {\hspace*{2.8cm}\color{white}\begin{varwidth}{\linewidth}\linespread{1.1}\headerfont\fontsize{12mm}{12mm}\selectfont#3\par\end{varwidth}}
        };

        \node[anchor=north west]
        at ([yshift=-134mm,xshift=-105.45mm] current page.north) {
            {\hspace*{2.8cm}\begin{varwidth}{\linewidth}\linespread{1.25}\huge\metafont\emph{#2}\par\end{varwidth}}
        };
    \end{tikzpicture}}
    
    \clearpage
}