# Modelling Search and Stopping in IIR
*Or, to use the full name, **Modelling Search and Stopping in Interactive Information Retrieval**.*

(A `bcs` branch of this repository exists for the version hosted by the British Computer Society.)

## Abstract
Searching for information when using a computerised retrieval system is a complex and inherently interactive process. Individuals during a search session may issue multiple queries, and examine a varying number of result summaries and documents per query. Searchers must also decide when to stop assessing content for relevance - or decide when to stop their search session altogether. Despite being such a fundamental activity, only a limited number of studies have explored stopping behaviours in detail, with a majority reporting that searchers stop because they decide that what they have found feels "good enough". Notwithstanding the limited exploration of stopping during search, the phenomenon is central to the study of Information Retrieval, playing a role in the models and measures that we employ. However, the current de facto assumption considers that searchers will examine k documents - examining up to a fixed depth.

In this thesis, we examine searcher stopping behaviours under a number of different search contexts. We conduct and report on two user studies, examining how result summary lengths and a variation of search tasks and goals affect such behaviours. Interaction data from these studies are then used to ground extensive simulations of interaction, exploring a number of different stopping heuristics (operationalised as twelve stopping strategies). We consider how well the proposed strategies perform and match up with real-world stopping behaviours. As part of our contribution, we also propose the Complex Searcher Model, a high-level conceptual searcher model that encodes stopping behaviours at different points throughout the search process. Within the Complex Searcher Model, we also propose a new results page stopping decision point. From this new stopping decision point, searchers can obtain an impression of the page before deciding to enter or abandon it.

Results presented and discussed demonstrate that searchers employ a range of different stopping strategies, with no strategy standing out in terms of performance and approximations offered. Stopping behaviours are clearly not fixed, but are rather adaptive in nature. This complex picture reinforces the idea that modelling stopping behaviour is difficult. However, simplistic stopping strategies do offer good performance and approximations, such as the frustration-based stopping strategy. This strategy considers a searcher's tolerance to non-relevance. We also find that combination strategies - such as those combining a searcher's satisfaction with finding relevant material, and their frustration towards observing non-relevant material - also consistently offer good approximations and performance. In addition, we also demonstrate that the inclusion of the additional stopping decision point within the Complex Searcher Model provides significant improvements to performance over our baseline implementation. It also offers improvements to the approximations of real-world searcher stopping behaviours.

This work motivates a revision of how we currently model the search process and demonstrates that different stopping heuristics need to be considered within the models and measures that we use in Information Retrieval. Measures should be reformed according to the stopping behaviours of searchers. A number of potential avenues for future exploration can also be considered, such as modelling the stopping behaviours of searchers individually (rather than as a population), and to explore and consider a wider variety of different stopping heuristics under different search contexts. Despite the inherently difficult task that understanding and modelling the stopping behaviours of searchers represents, potential benefits of further exploration in this area will undoubtedly aid the searchers of future retrieval systems - with further work bringing about improved interfaces and experiences.

## About this Repository
This repository contains the PhD thesis written by **David Martin Maxwell**. This work was undertaken at the [**University of Glasgow, Scotland**](https://www.gla.ac.uk/schools/computing/), from October 2013-June 2019. David was supervised by [**Dr. Leif Azzopardi**](http://leifos.me) and [**Professor Roderick Murray-Smith**](http://www.dcs.gla.ac.uk/~rod/).

Source *XeTeX* code for the thesis itself is contained within the `thesis` directory. All of the source configuration files for my simulations of interaction can be found in the `simulations` directory. Unfortunately, experimental raw results and summary files are way too large to host on GitHub; if you want any raw data, [please contact me](mailto:maxwelld90@acm.org). I have it backed up in several locations.

I created my own thesis template which complies with University of Glasgow College of Science and Engineering rules. It looks very different from other theses. I am very proud of the [blood, sweat and tears that went into this](http://www.dmax.org.uk/things/phd/writing-up/). I thought that in the interests of transparency, it would be good to make sure everything is released into the open for people to see. Note that I use special fonts and make use of stock images throughout the thesis; please refer to [this README](https://github.com/maxwelld90/phd/blob/master/thesis/fonts/README.md) and [this other README](https://github.com/maxwelld90/phd/blob/master/thesis/figures/README.md) for more information.

**Contact:** David Maxwell (maxwelld90@acm.org, or [@maxwelld90](https://twitter.com/maxwelld90/))

**PDF:** You can find it on [my personal website](https://www.dmax.org.uk/thesis/).

I kindly ask that when citing this work, please use the following BibTeX entry:

```
@phdthesis{maxwell2019thesis,
  title={Modelling Search and Stopping in Interactive Information Retrieval},
  author={Maxwell, David},
  school={University of Glasgow, Scotland},
  year={2019},
  month={April},
}
```

That is all. Go nuts. **But please make sure you reference me if you use any of this work.**