;Main Module-----------
(import nrc.fuzzy.*)

;Template for Questions
(deftemplate question 
    	(slot text)
    	(slot answerType)
    	(slot topic))

;Template for Answers
(deftemplate answer
    	(slot text)
    	(slot topic))

;Template for Suggestions
(deftemplate suggestions
    	(slot planet)
    	(slot description)
    	(slot moreInfo))

;Global Variables--------------
;Considering this range as per current research
;Distance from Earth
(defglobal ?*gVarDistanceFromEarth* = (new nrc.fuzzy.FuzzyVariable "distanceFromEarth" 0.0 28000.0 "ly"))
;Temperature of ExoPlanet (Effective temperature)
(defglobal ?*gVarTemperature* = (new nrc.fuzzy.FuzzyVariable "temperature" 0 8000 "K"))
;Closeness to Parent Star
(defglobal ?*gVarDistanceParentStar* = (new nrc.fuzzy.FuzzyVariable "distanceParentStar" 0.0 400000.0 "d"))
;Radius in terms of Earth Units
(defglobal ?*gVarSize* = (new nrc.fuzzy.FuzzyVariable "size" 0 500 "EU"))
;When was it discovered
(defglobal ?*gVarDiscoveryTime* = (new nrc.fuzzy.FuzzyVariable "discovery" 1900 2017))

(call nrc.fuzzy.FuzzyValue setMatchThreshold 0.1)


;List of Questions to be asked------------
(deffacts question
    "System asked Questions"
    (question (topic distanceFromEarth) (answerType number)
        (text "Q.How far from earth should the planet be? [Choose from options 1 - 3]
            1.Close by
            2.A bit further
            3.Really far away
            Choose a number - "))
    (question (topic temperature) (answerType number)
        (text "Q.How hot should the planet be? [Choose from options 1 - 4]
            1.Really hot
            2.Hot
            3.Warm
            4.Cool
            5.Really cold
            Choose a number - "))
    (question (topic distanceParentStar) (answerType number)
        (text "Q.How close to its star should the planet be? [Choose from options 1 - 3]
            1.Super close
            2.Not that close
            3.Far Away
            Choose a number - "))
    (question (topic size) (answerType number)
        (text "Q.How big should the planet be? [Choose from options 1 - 3]
            1.Huge
            2.Kinda like earth
            3.Tiny
            Choose a number - "))
    (question (topic discovery) (answerType number)
        (text "Q.Do you want a planet from the recently discovered ones? [Choose from options 1 - 2]
            1.Yes, Somthing from the recently discovered list
            2.Nah, Something discovered much earlier
            Choose a number - "))
    )
(defglobal ?*crlf* = " ")

;Functions to map answers---------------
(deffunction mapDistanceEarth (?ans)
    "Mapping Distance From Earth to a Value"
    (if (eq ?ans 1) then (assert (valDistanceFromEarth (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromEarth* "closeBy"))))
    (if (eq ?ans 2) then (assert (valDistanceFromEarth (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromEarth* "far"))))
    (if (eq ?ans 3) then (assert (valDistanceFromEarth (new nrc.fuzzy.FuzzyValue ?*gVarDistanceFromEarth* "veryFar"))))
)

(deffunction mapTemperature (?ans)
    "Mapping Temperature to a Value"
    (if (eq ?ans 1) then (assert (valTemperature (new nrc.fuzzy.FuzzyValue ?*gVarTemperature* "veryHot"))))
    (if (eq ?ans 2) then (assert (valTemperature (new nrc.fuzzy.FuzzyValue ?*gVarTemperature* "hot"))))
    (if (eq ?ans 3) then (assert (valTemperature (new nrc.fuzzy.FuzzyValue ?*gVarTemperature* "warm"))))
    (if (eq ?ans 4) then (assert (valTemperature (new nrc.fuzzy.FuzzyValue ?*gVarTemperature* "cold"))))
    (if (eq ?ans 5) then (assert (valTemperature (new nrc.fuzzy.FuzzyValue ?*gVarTemperature* "veryCold"))))
)

(deffunction mapDistanceParentStar (?ans)
    "Mapping Distance From Parent Star to a Value"
    (if (eq ?ans 1) then (assert (valDistanceParentStar (new nrc.fuzzy.FuzzyValue ?*gVarDistanceParentStar* "closeBy"))))
    (if (eq ?ans 2) then (assert (valDistanceParentStar (new nrc.fuzzy.FuzzyValue ?*gVarDistanceParentStar* "far"))))
    (if (eq ?ans 3) then (assert (valDistanceParentStar (new nrc.fuzzy.FuzzyValue ?*gVarDistanceParentStar* "veryFar"))))
)

(deffunction mapSize (?ans)
    "Mapping Distance From Radius of a Star to a Value"
    (if (eq ?ans 1) then (assert (valSize (new nrc.fuzzy.FuzzyValue ?*gVarSize* "big"))))
    (if (eq ?ans 2) then (assert (valSize (new nrc.fuzzy.FuzzyValue ?*gVarSize* "medium"))))
    (if (eq ?ans 3) then (assert (valSize (new nrc.fuzzy.FuzzyValue ?*gVarSize* "small"))))
)

(deffunction mapDiscoveryDate (?ans)
    "Mapping Discovery Time to a Value"
    (if (eq ?ans 1) then (assert (valDiscovery (new nrc.fuzzy.FuzzyValue ?*gVarDiscoveryTime* "new"))))
    (if (eq ?ans 2) then (assert (valDiscovery (new nrc.fuzzy.FuzzyValue ?*gVarDiscoveryTime* "old"))))
)

;Initialization Module-----------------
(defmodule initialize)
(defrule initialize
    (declare (salience 100))
    =>
    (load-package nrc.fuzzy.jess.FuzzyFunctions)
    
    ;Distance From Earth
    (bind ?xCloseBy (create$ 4.0 14000.0))
    (bind ?yCloseBy (create$ 1.0 0.0))
    (?*gVarDistanceFromEarth* addTerm "closeBy" ?xCloseBy ?yCloseBy 2)
    (bind ?xfar (create$ 14000.0 27999.0))
    (bind ?yfar (create$ 0.0 1.0))
    (?*gVarDistanceFromEarth* addTerm "far" ?xfar ?yfar 2)
    (?*gVarDistanceFromEarth* addTerm "veryFar" "very far")
    
    ;Temperature
    (bind ?xhot (create$ 500.0 2000.0))
    (bind ?yhot (create$ 0.0 1.0))
    (?*gVarTemperature* addTerm "hot" ?xhot ?yhot 2)
    (bind ?xcold (create$ 50.0 500.0))
    (bind ?ycold (create$ 1.0 0.0))
    (?*gVarTemperature* addTerm "cold" ?xcold ?ycold 2)
    (?*gVarTemperature* addTerm "veryHot" "very hot")
    (?*gVarTemperature* addTerm "veryCold" "very cold")
    (?*gVarTemperature* addTerm "warm" "not hot and (not cold)")
    
    ;Distance From Parent Star
    (bind ?xCloseBy (create$ 0.01 15))
    (bind ?yCloseBy (create$ 1.0 0.0))
    (?*gVarDistanceParentStar* addTerm "closeBy" ?xCloseBy ?yCloseBy 2)
    (bind ?xfar (create$ 15 400000))
    (bind ?yfar (create$ 0.0 1.0))
    (?*gVarDistanceParentStar* addTerm "far" ?xfar ?yfar 2)
    (?*gVarDistanceParentStar* addTerm "veryFar" "very far") 
    
    ;Size of planet
 	  (bind ?xBig (create$ 2 500))
    (bind ?yBig (create$ 0.0 1.0))
    (?*gVarSize* addTerm "big" ?xBig ?yBig 2)
    (bind ?xSmall (create$ 0 2))
    (bind ?ySmall (create$ 1.0 0.0))
    (?*gVarSize* addTerm "small" ?xSmall ?ySmall 2)
    (?*gVarSize* addTerm "medium" "not big and (not small)") 
    
    ;Discovery Time
    (bind ?xOld (create$ 1900 2010))
    (bind ?yOld (create$ 1.0 0.0))
    (?*gVarDiscoveryTime* addTerm "old" ?xOld ?yOld 2)
    (bind ?xNew (create$ 2010 2017))
    (bind ?yNew (create$ 0.0 1.0))
    (?*gVarDiscoveryTime* addTerm "new" ?xNew ?yNew 2)
    )

;Ask Questions Module--------------
(defmodule ask)
(deffunction askUser (?question ?answerType ?topic)
"Fetch answers from posed questions"
(bind ?answer "")
(while (not (numberp ?answer)) do      
(printout t ?question " ")
(bind ?answer (read)))
    (if(eq ?topic distanceFromEarth) then (mapDistanceEarth ?answer))
    (if(eq ?topic temperature) then (mapTemperature ?answer))
    (if(eq ?topic distanceParentStar) then (mapDistanceParentStar ?answer))
    (if(eq ?topic size) then (mapSize ?answer))
    (if(eq ?topic discovery) then (mapDiscoveryDate ?answer))
(return ?answer))

;Ask Individual Questions based on Topic
(defrule ask::askQuestionByTopic
"Ask questions based on topic and store answers"
	(declare (auto-focus TRUE))
	(MAIN::question (topic ?topic) (text ?text) (answerType ?answerType))
	(not (MAIN::answer (topic ?topic)))
	?ask <- (MAIN::ask ?topic)
=>
	(bind ?answer (askUser ?text ?answerType ?topic))
	(assert (answer (topic ?topic) (text ?answer)))
)

;Welcome Module which displays the initial message------------------
(defmodule welcome)
(defrule welcomeMessage
    =>
    (printout t "------------Welcome to find me an ExoPlanet------------" crlf)
    (printout t "Do you not know a lot about astronomy and still want to find that particular planet?" crlf)
    (printout t "Well then this system is just for you." crlf)
   	(printout t "Type your name and press <Enter>: ")
	  (bind ?name (read))
    (printout t "Hello "?name crlf)
    (printout t "Answer the following questions which will help us understand what your requirements" crlf)
)

;FetchAnswers Module gets the answers from the user
(defmodule fetchAnswers)
(defrule fetchDistanceFromEarth
    =>
    (assert (ask distanceFromEarth))
)

(defrule fetchTemperature
    =>
    (assert (ask temperature))
)

(defrule fetchDistanceParentStar
    =>
    (assert (ask distanceParentStar))
)

(defrule fetchSize
    =>
    (assert (ask size))
)

(defrule fetchDiscovery
    =>
    (assert (ask discovery))
)

;Planet Suggestions -----------------
(defmodule suggest)

;Suggestion 1
(defrule ProximaCentaurib
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less closeBy"))
	  (valTemperature ?t&: (fuzzy-match ?t "more_or_less cold"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "old"))
    =>
    (assert (MAIN::suggestions
            (planet "Proxima Centauri b")
            (description "Details : 
                Distance from Earth : 4.2 Ly
                Orbital Period : 11.186 Days
                Temperature : 234 K
                Discovered in : 1915")
            (moreInfo "https://en.wikipedia.org/wiki/Proxima_Centauri_b")))
)

;Suggestion 2
(defrule SWEEPS-11
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "veryFar"))
	  (valTemperature ?t&: (fuzzy-match ?t "hot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less big"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "old"))
    =>
    (assert (MAIN::suggestions
            (planet "SWEEPS 11")
            (description "Details : 
                Distance from Earth : 27,710 Ly
                Orbital Period : 1.79 Days
                Temperature : 818.7 K
                Discovered in : 2006")
            (moreInfo "https://en.wikipedia.org/wiki/SWEEPS-11")))
)

;Suggestion 3
(defrule HAT-P-32b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less veryFar"))
	(valTemperature ?t&: (fuzzy-match ?t "veryHot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "very big"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "HAT-P-32b")
            (description "Details : 
                Distance from Earth : 923 Ly
                Orbital Period : 2.15 Days
                Temperature : 1677 K
                Discovered in : 2011")
            (moreInfo "https://en.wikipedia.org/wiki/HAT-P-32b")))
)	

;Suggestion 4
(defrule Wolf1061c
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less closeBy"))
	  (valTemperature ?t&: (fuzzy-match ?t "more_or_less cold"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less far"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "Wolf 1061 c")
            (description "Details : 
                Distance from Earth : 14 Ly
                Orbital Period : 17.9 Days
                Temperature : 223 K
                Discovered in : 2015")
            (moreInfo "https://en.wikipedia.org/wiki/Wolf_1061c")))
)	

;Suggestion 5
(defrule Kepler186f
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less closeBy"))
	  (valTemperature ?t&: (fuzzy-match ?t "cold"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less veryFar"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "Kepler-186 f")
            (description "Details : 
                Distance from Earth : 561 Ly
                Orbital Period : 129.9 Days
                Temperature : 188 K
                Discovered in : 2014")
            (moreInfo "https://en.wikipedia.org/wiki/Kepler-186f")))
)

;Suggestion 6
(defrule Kepler438b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less closeBy"))
	  (valTemperature ?t&: (fuzzy-match ?t "more_or_less warm"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "more_or_less far"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less small"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "Kepler-438 b")
            (description "Details : 
                Distance from Earth : 473 Ly
                Orbital Period : 35.2 Days
                Temperature : 276 K
                Discovered in : 2015")
            (moreInfo "https://en.wikipedia.org/wiki/Kepler-438b")))
)

;Suggestion 7
(defrule GJ163c
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less closeBy"))
  	(valTemperature ?t&: (fuzzy-match ?t "cold"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "GJ 163 c")
            (description "Details : 
                Distance from Earth : 49 Ly
                Orbital Period : 25.6 Days
                Temperature : 230 K
                Discovered in : 2012")
            (moreInfo "https://en.wikipedia.org/wiki/Gliese_163_c")))
)

;Suggestion 8
(defrule Kepler440b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less far"))
  	(valTemperature ?t&: (fuzzy-match ?t "warm"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "far"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "Kepler-440 b")
            (description "Details : 
                Distance from Earth : 851 Ly
                Orbital Period : 101.1 Days
                Temperature : 273 K
                Discovered in : 2015")
            (moreInfo "https://en.wikipedia.org/wiki/Kepler-440b")))
)

;Suggestion 9
(defrule Kepler70b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "more_or_less veryFar"))
  	(valTemperature ?t&: (fuzzy-match ?t "very hot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "very closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "very small"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "Kepler-70 b")
            (description "Details : 
                Distance from Earth : 3848.6 Ly
                Orbital Period : 5.76 Days
                Temperature : 7143 K
                Discovered in : 2011")
            (moreInfo "https://en.wikipedia.org/wiki/Kepler-70b")))
)

;Suggestion 10
(defrule OGLE-2005-BLG-390Lb
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "very veryFar"))
	  (valTemperature ?t&: (fuzzy-match ?t "very veryCold"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "very veryFar"))
    (valSize ?vS&: (fuzzy-match ?vS "more_or_less medium"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "old"))
    =>
    (assert (MAIN::suggestions
            (planet "OGLE-2005-BLG-390Lb")
            (description "Details : 
                Distance from Earth : 20000 Ly
                Orbital Period : 3500 Days
                Temperature : 50 K
                Discovered in : 2005")
            (moreInfo "https://en.wikipedia.org/wiki/OGLE-2005-BLG-390Lb")))
)

;Suggestion 11
(defrule HD100546b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "closeBy"))
    (valTemperature ?t&: (fuzzy-match ?t "very hot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "very veryFar"))
    (valSize ?vS&: (fuzzy-match ?vS "very big"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "new"))
    =>
    (assert (MAIN::suggestions
            (planet "HD 100546 b")
            (description "Details : 
                Distance from Earth : 320 Ly
                Orbital Period : 4015 Days
                Temperature : 1028 K
                Discovered in : 2013")
            (moreInfo "https://en.wikipedia.org/wiki/HD_100546#HD_100546_b")))
)

;Suggestion 12
(defrule HR8799b
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "closeBy"))
  	(valTemperature ?t&: (fuzzy-match ?t "very hot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "very veryFar"))
    (valSize ?vS&: (fuzzy-match ?vS "big"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "old"))
    =>
    (assert (MAIN::suggestions
            (planet "HR 8799 b")
            (description "Details : 
                Distance from Earth : 128.50 Ly
                Orbital Period : 164250 Days
                Temperature : 870 K
                Discovered in : 2008")
            (moreInfo "https://en.wikipedia.org/wiki/HR_8799_b")))
)

;Suggestion 13
(defrule HD40307c
  	(valDistanceFromEarth ?dE&: (fuzzy-match ?dE "closeBy"))
	  (valTemperature ?t&: (fuzzy-match ?t "hot"))
    (valDistanceParentStar ?dP&: (fuzzy-match ?dP "closeBy"))
    (valSize ?vS&: (fuzzy-match ?vS "big"))
    (valDiscovery ?dT&: (fuzzy-match ?dT "old"))
    =>
    (assert (MAIN::suggestions
            (planet "HD 40307 c")
            (description "Details : 
                Distance from Earth : 12.8 Ly
                Orbital Period : 9.61 Days
                Temperature : 617 K
                Discovered in : 2008")
            (moreInfo "https://en.wikipedia.org/wiki/HD_40307_c")))
)

;Sums up all the results---------------
(defmodule report)
(defquery getResults
    (MAIN::suggestions 
        (planet ?planet)
        (description ?description)
        (moreInfo ?moreInfo))
)

;Displays all the results---------------
(defrule getAllResults
    =>
    (bind ?result (run-query* getResults))
    (bind ?i 0)
    (printout t crlf "---------These planets fit your criteria--------"crlf)
    (while (?result next) do
        (printout t crlf)
      	(printout t "Planet Name : " (?result getString planet) crlf)
      	(printout t "Planet Description : " (?result getString description) crlf)
      	(printout t "More Information : " (?result getString moreInfo) crlf)
      	(++ ?i))
    (if (eq ?i 0) then
        (printout t "Oops we didn't find any planet that matched your requirements.You should try something else." crlf))
    )

;Initialize application
(reset)
(focus initialize welcome fetchAnswers suggest report)
(run)


;All the above values are subject to change based on the current state of research
