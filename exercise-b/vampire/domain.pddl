(define (domain vampire)
    (:requirements :conditional-effects)
    (:predicates
        (light-on ?r)
        (slayer-is-alive)
        (slayer-is-in ?r)
        (vampire-is-alive)
        (vampire-is-in ?r)
        (fighting)
        ;
        ; static predicates
        (NEXT-ROOM ?r ?rn)
        (CONTAINS-GARLIC ?r)
    )

    (:action toggle-light
        :parameters (?anti-clockwise-neighbor ?room ?clockwise-neighbor)
        :precondition (and
            (NEXT-ROOM ?anti-clockwise-neighbor ?room)
            (NEXT-ROOM ?room ?clockwise-neighbor)
            (not (fighting))
        )
        :effect (and
            (when
                (not (light-on ?room))
                (and
                    (light-on ?room)
                    (when 
                        (vampire-is-in ?room)
                        (and 
                            (not (vampire-is-in ?room))
                            (when 
                                (not (light-on ?anti-clockwise-neighbor))
                                (and
                                    (vampire-is-in ?anti-clockwise-neighbor)
                                    (when
                                        (slayer-is-in ?anti-clockwise-neighbor)
                                        (fighting)
                                    )
                                )
                            )
                            (when
                                (light-on ?anti-clockwise-neighbor)
                                (and
                                    (vampire-is-in ?clockwise-neighbor)
                                    (when
                                        (slayer-is-in ?clockwise-neighbor)
                                        (fighting)
                                    )
                                )
                            ) 
                        )
                    )
                )
            )
            (when
                (light-on ?room)
                (and
                    (not (light-on ?room))
                    (when 
                        (slayer-is-in ?room)
                        (and 
                            (not (slayer-is-in ?room))
                            (when 
                                (light-on ?clockwise-neighbor)
                                (and
                                    (slayer-is-in ?clockwise-neighbor)
                                    (when
                                        (vampire-is-in ?clockwise-neighbor)
                                        (fighting)
                                    )
                                )
                            )
                            (when
                                (not (light-on ?clockwise-neighbor))
                                (and
                                    (slayer-is-in ?anti-clockwise-neighbor)
                                    (when
                                        (vampire-is-in ?anti-clockwise-neighbor)
                                        (fighting)
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )

    (:action watch-fight
        :parameters (?room)
        :precondition (and
            (slayer-is-in ?room)
            (slayer-is-alive)
            (vampire-is-in ?room)
            (vampire-is-alive)
            (fighting)
        )
        :effect (and
            (not (fighting))
            (when 
                (CONTAINS-GARLIC ?room)
                (not (vampire-is-alive))
            )
            (when
                (light-on ?room)
                (not (vampire-is-alive))
            )
            (when
                (and
                    (not (CONTAINS-GARLIC ?room))
                    (not (light-on ?room))
                )
                (not (slayer-is-alive))
            )
        )
    )
)
