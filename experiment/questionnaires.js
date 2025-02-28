const questionnaires_instructions = {
    type: jsPsychHtmlButtonResponse,
    stimulus:
        "<h2>Questionnaires</h2>" +
        "<p>We will continue with a series of questionnaires.<br>It is important that you answer truthfully. Please read the statements carefully and answer according to what describe you the best.</p>",
    choices: ["Continue"],
    data: { screen: "questionnaire_instructions" },
}

// Convernience function to shuffle an object (used internally)
function shuffleObject(obj) {
    const entries = Object.entries(obj)
    for (let i = entries.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
            ;[entries[i], entries[j]] = [entries[j], entries[i]]
    }
    return Object.fromEntries(entries)
}

// Items =================================================
// Mini-IPIP6 questionnaire (Sibley, 2011)
const ipip6_items = {
    Extraversion_1: "I am the life of the party",
    Agreeableness_2: "I sympathise with others' feelings",
    Conscientiousness_3: "I get chores done right away",
    Neuroticism_4: "I have frequent mood swings",
    Openness_5: "I have a vivid imagination",
    HonestyHumility_6_R: "I feel entitled to more of everything",
    Extraversion_7_R: "I don't talk a lot",
    Agreeableness_8_R: "I am not interested in other people's problems",
    Openness_9_R: "I have difficulty understanding abstract ideas",
    Conscientiousness_10: "I like order",
    Conscientiousness_11_R: "I make a mess of things",
    HonestyHumility_12_R: "I deserve more things in life",
    Openness_13_R: "I do not have a good imagination",
    Agreeableness_14: "I feel others' emotions",
    Neuroticism_15_R: "I am relaxed most of the time",
    Neuroticism_16: "I get upset easily",
    Neuroticism_17_R: "I seldom feel blue",
    HonestyHumility_18_R: "I would like to be seen driving around in a really expensive car",
    Extraversion_19_R: "I keep in the background",
    Agreeableness_20_R: "I am not really interested in others",
    Openness_21_R: "I am not interested in abstract ideas",
    Conscientiousness_22_R: "I often forget to put things back in their proper place",
    Extraversion_23: "I talk to a lot of different people at parties",
    HonestyHumility_24_R: "I would get a lot of pleasure from owning expensive luxury goods",
}

// Format IPIP6 items ------------------------------------------------
function ipip6_questions(items, required = true, ticks = ["Inaccurate", "Accurate"]) {
    items = shuffleObject(items)

    //Make questions
    questions = []
    for (const key of Object.keys(items)) {
        q = {
            title: items[key],
            name: key,
            type: "rating",
            displayMode: "buttons",
            isRequired: required,
            minRateDescription: ticks[0],
            maxRateDescription: ticks[1],
            rateValues: [1, 2, 3, 4, 5, 6, 7],
        }
        questions.push(q)
    }
    return [
        {
            elements: questions,
            description: "Please answer the following questions based on how accurately each statement describes you in general.",
        }
    ]
}

// IPIP
const ipip6_questionnaire = {
    type: jsPsychSurvey,
    survey_json: {
        title: "About your personality...",
        showQuestionNumbers: false,
        goNextPageAutomatic: true,
        pages: ipip6_questions(ipip6_items),
    },
    data: {
        screen: "questionnaire_ipip6",
    },
}

// Brief Personality Inventory for DSM-V (PID-5) - Maladaptive Traits
const pid_items = {
    Disinhibition_1: "People would describe me as reckless",
    Disinhibition_2: "I feel like I act totally on impulse",
    Disinhibition_3: "Even though I know better, I can't stop making rash decisions",
    Detachment_4: "I often feel like nothing I do really matters",
    Disinhibition_5: "Others see me as irresponsible",
    Disinhibition_6: "I'm not good at planning ahead",
    Psychoticism_7: "My thoughts often don't make sense to others",
    NegativeAffect_8: "I worry about almost everything",
    NegativeAffect_9: "I get emotional easily, often for very little reason",
    NegativeAffect_10: "I fear being alone in life more than anything else",
    NegativeAffect_11: "I get stuck on one way of doing things, even when it's clear it won't work",
    Psychoticism_12: "I have seen things that weren't really there",
    Detachment_13: "I steer clear of romantic relationships",
    Detachment_14: "I'm not interested in making friends",
    NegativeAffect_15: "I get irritated easily by all sorts of things",
    Detachment_16: "I don't like to get too close to people",
    Antagonism_17: "It's no big deal if I hurt other people's feelings",
    Detachment_18: "I rarely get enthusiastic about anything",
    Antagonism_19: "I crave attention",
    Antagonism_20: "I often have to deal with people who are less important than me",
    Psychoticism_21: "I often have thoughts that make sense to me but that other people say are strange",
    Antagonism_22: "I use people to get what I want",
    Psychoticism_23: "I often 'zone out' and then suddenly come to and realise that a lot of time has passed",
    Psychoticism_24: "Things around me often feel unreal, or more real than usual",
    Antagonism_25: "It is easy for me to take advantage of others",
}


const instructions_pid = {
    type: "html",
    name: "instructions_pid",
    html: "<p>Below is a list of things different people might say about themselves. Please select the response that best describes you.</p>",
}


// Format PID-5 items ------------------------------------------------
function pid5_questions(items, required = true) {
    items = shuffleObject(items)
    questions = [instructions_pid]

    // Make questions
    for (const key of Object.keys(items)) {
        q = {
            title: items[key],
            name: key,
            type: "rating",
            displayMode: "buttons",
            isRequired: required,
            rateValues: [
                {
                    value: 0,
                    text: "Very or Often False",
                },
                {
                    value: 0.5,
                    text: "Sometimes or Somewhat False",
                },
                {
                    value: 1,
                    text: "Sometimes or Somewhat True",
                },
                {
                    value: 2,
                    text: "Very or Often True",
                },
            ],
        }
        questions.push(q)
    }

    return { elements: questions }
}

const pid5_questionnaire = {
    type: jsPsychSurvey,
    survey_json: {
        title: "About yourself... ",
        showQuestionNumbers: false,
        goNextPageAutomatic: true,
        pages: pid5_questions(pid_items),
    },
    data: {
        screen: "questionnaire_pid5",
    },
}
