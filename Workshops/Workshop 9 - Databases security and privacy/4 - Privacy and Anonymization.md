# Privacy and Anonymization

## What is privacy
Privacy refers to an individual’s right to control how their personal information is collected, processed, stored, and shared. In data technologies, privacy is not just a legal obligation but a design principle: systems should be built to minimize the risk of identifying individuals.

### Key Terms
- **Personally Identifiable Information (PII):** Data that directly identifies a person.
- **Indirect identifiers / quasi-identifiers:** Attributes that may identify a person when combined with external datasets.
- **Sensitive Attributes:** Attributes that reveal private, personal, or potentially harmful information about an individual, even if they do not identify the person directly.

## Why is privacy important

### 1. Human Perspective
- Protects autonomy and dignity.
- Reduces risks of profiling, discrimination, or reputational damage.

### 2. Organizational Perspective
- Prevents legal and financial consequences after breaches.
- Builds trust among users and clients.

### 3. Technical Perspective
- In modern analytics and AI, linking datasets is easy, increasing re-identification risks.
- Privacy must be integrated into data modelling, access control, and processing pipelines.

## GDPR and AVG

The GDPR (General Data Protection Regulation) and its Dutch implementation, the AVG, regulate how organizations handle personal data.

### Core Principles
- **Lawfulness, fairness, transparency**
   - **Lawfulness**: Processing must have a legal basis (e.g. consent, contract)
   - **Fairness**:  Data must be processed in a way the data subject would reasonably expect.
   - **Transparency**: Organizations must be open about data processing and clearly inform data subjects.    
- **Purpose limitation**: Personal data must be collected for specified, explicit, and legitimate purposes and not further processed in a manner incompatible with those purposes.
- **Data minimization**: Processing must be adequate, relevant, and limited to what is necessary in relation to the purposes for which the data are processed.
- **Accuracy**: Personal data must be accurate and, where necessary, kept up to date.
- **Storage limitation**: Data must be kept for no longer than is necessary for the purposes for which the personal data are processed (i.e., retention policies must be in place).
- **Integrity and confidentiality**: Processing must ensure appropriate security of the personal data, including protection against unauthorized or unlawful processing and against accidental loss, destruction, or damage.
- **Accountability**: The data controller must be able to demonstrate compliance with all the above principles (e.g., through documentation, policies, and records of processing activities).

### Case: Applying GDPR to a Newsletter Database

Using the core principles of the GDPR, consider the following questions related to managing a customer newsletter subscription database.

🧠 Lawfulness: What is the most critical legal basis required before an organization can send a newsletter to a recipient?

<details> <summary>Click to reveal a answer</summary>
The organization must obtain explicit, unambiguous consent from the recipient (the data subject). This consent must be freely given and specific to receiving the newsletter.
</details>

\
🧠 Transparency: What mechanism must be in place to ensure compliance with the transparency principle regarding subscriptions?
<details> <summary>Click to reveal a answer</summary>
The sender must provide a clear and easy-to-use opt-out (unsubscribe) mechanism in every newsletter. Furthermore, the privacy policy must transparently explain how the subscriber's data is processed.
</details>

\
🧠 Purpose: The newsletter database stores the recipient’s email address and name. According to the Purpose Limitation principle, can this data be used to send the recipient an unrelated sales survey from a third-party partner?
<details> <summary>Click to reveal a answer</summary>
No. The email address and name were collected specifically for the purpose of sending the newsletter. Using this data for a third-party sales survey would constitute further processing that is incompatible with the original, explicit purpose.
</details>

\
🧠 Data Minimization: Besides the email address and name, the database currently stores the recipient's IP address at signup and date of birth. Which of these fields should likely be removed to comply with data minimization?
<details> <summary>Click to reveal a answer</summary>
The date of birth is almost certainly unnecessary for sending a generic newsletter. The IP address is generally not required for subscriber management and should be removed or pseudonymized/aggregated, unless there is a specific legal requirement (like fraud prevention) to keep it.
</details>

\
🧠 Data Minimization & Relevance: The newsletter provider also tracks clicks on links within the email. Is storing this click data per individual recipient compliant with Data Minimization?
<details> <summary>Click to reveal a answer</summary>
This is a gray area. Storing clicks for performance analysis and aggregated statistics is often justifiable. However, if the tracking is used to create individual user profiles for targeted advertising unrelated to the newsletter service, it may violate the principle, as it goes beyond what is necessary for the core service.
</details>   

\
🧠 Accuracy: How can the organization best ensure the Accuracy of the email addresses and names stored in the newsletter database?
<details> <summary>Click to reveal a answer</summary>
The most direct method is to provide the data subject with a secure, self-service way to view and update their own personal details (like name or email address). This delegates the responsibility for accuracy back to the data subject.
</details>

\
🧠 Accountability: The Accountability principle requires the organization to demonstrate GDPR compliance. When challenged, how can the newsletter administrator prove that a recipient consented to receive the newsletter?
<details> <summary>Click to reveal a answer</summary>
The organization must maintain a verifiable record of consent (a proof of consent). This typically involves implementing a double opt-in system and storing the following evidence: the time, date, method, and the IP address used for the initial and final confirmation of the subscription.
</details>

## Anonymization & Pseudonimisation

Anonymization is the process of rendering personal data into a form that the data subject is no longer identifiable. So the link to the individual is permanently and irreversibly broken.

Pseudonimisation is process of replacing direct identifiers (like name or SSN) with a pseudonym (e.g., an artificial identifier) so that the data can no longer be attributed to a specific data subject without the use of additional information.

### Relevance for GDPR
- Truly anonymized data falls *outside* GDPR.
- Pseudonymized data still falls *inside* GDPR because re-identification remains possible.

### Common Techniques for anonymization
- **Generalization:** Replace specific values with broader categories.
- **Suppression:** Remove attributes entirely.
- **Masking:** Concealing specific parts of data to prevent exposure.
- **Noise addition:** Add small random variations.
- **Sampling:** Release only part of the dataset.
- **Permutation:** Shuffle values between records.

**Example**:

Before anonymization:

| Person             | Age | Income  | ZIP Code | IBAN                       |
| ------------------ | --- | ------- | -------- | -------------------------- |
| Arthur Pendragon   | 34  | 42,000  | 3012AB   | NL37 ABNA 1234 5678 90 |
| Caspian Bloodstone | 37  | 51,000  | 3012CE   | NL91 RABO 8765 4321 09 |
| Lyra Willowby      | 41  | 145,000 | 3015DD   | NL12 INGB 1020 3040 55 |
| Eira Frost         | 45  | 235,000 | 3015DG   | NL44 SNSB 9988 7766 55 |


After anonymization:

| Person (suppression) | Age (generalized) | Income (generalized) | ZIP Code (generalized) | IBAN (masking)             |
| -------------------- | ----------------- | -------------------- | ---------------------- | -------------------------- |
| ***                  | 30–39             | 40k–60k              | 3012                   | NL37 ABNA **** **** 90 |
| ***                  | 30–39             | 40k–60k              | 3012                   | NL91 RABO **** **** 09 |
| ***                  | 40–49             | 100k–200k            | 3015                   | NL12 INGB **** **** 55 |
| ***                  | 40–49             | 200k–300k            | 3015                   | NL44 SNSB **** **** 55 |




### Quasi-identifiers

Quasi-identifiers are attributes that don’t uniquely identify a person on their own but may do so when combined.

Examples:
- Postal code + birthdate
- Gender + age + municipality
- Education level + department + salary

A famous result:  
**87% of the U.S. population is uniquely identifiable by ZIP code + birthdate + gender.**

### Exercise — Identifying PII and Quasi-Identifiers

You are working as a developer for a sports association that stores member data for registration and health screening.
Below is a (fictional) dataset containing personal and health-related attributes. 

> Systolic BP (Systolic Blood Pressure) is the upper blood pressure value.

| Member ID | Full Name         | Date of Birth | Gender | ZIP Code | Weight (kg) | Systolic BP | Sport Level  | Email Address                                                 | Phone Number |
| --------- | ----------------- | ------------- | ------ | -------- | ----------- | ----------- | ------------ | ------------------------------------------------------------- | ------------ |
| 1021      | Anna Koster       | 2004-08-21    | F      | 3012AB   | 67          | 118         | Intermediate | [anna.koster@example.com](mailto:anna.koster@example.com)     | 0612345678   |
| 1044      | Brian van Leeuwen | 1998-03-11    | M      | 3015CE   | 92          | 130         | Advanced     | [brianvleeuwen@example.com](mailto:brianvleeuwen@example.com) | 0688776655   |
| 1088      | David Chen        | 2006-11-05    | M      | 3013DD   | 74          | 121         | Beginner     | [davidc@example.com](mailto:davidc@example.com)               | 0644455566   |
| 1112      | Sara El Mansouri  | 1991-01-17    | F      | 3012GH   | 81          | 135         | Advanced     | [saraelm@example.com](mailto:saraelm@example.com)             | 0611992277   |

🧠 Question 1 — Identify the PII (Direct Identifiers)
Which attributes directly and uniquely identify a specific person?

<details><summary>Click to reveal answer</summary>
Expected answers include:

- Full Name
- Email Address
- Phone Number
- Member ID (if membership numbers are unique)



Direct identifiers allow you to immediately know who the person is, without combining multiple attributes.
</details>

\
🧠 Question 2 — Identify the Quasi-Identifiers


<details><summary>Click to reveal answer</summary>
Quasi-identifiers do not identify someone by themselves but can identify a person when combined with other attributes or external datasets.

\
In this dataset, quasi-identifiers may include:

- Date of Birth
- Gender
- ZIP Code
- Sport Level
- Weight
- Systolic BP

Note:
Attributes like “Weight” or “Sport Level” may seem harmless, but in small populations (like a sports club), they can make individuals uniquely identifiable.
</details>

\
🧠 Question 3 — Identify Sensitive Attributes that are not Direct Identifiers


<details><summary>Click to reveal answer</summary>
Some attributes are sensitive but do not directly identify a person.

Examples:
- Weight
- Systolic BP
- Sport Level

These reveal something about the member’s health or lifestyle but do not identify them on their own.
</details>

### Sensitive attributes

A sensitive attribute is an attribute that reveals information about a person that could cause harm, embarrassment, discrimination, or unwanted exposure if disclosed. Sensitive attributes do not necessarily identify someone directly — instead, they reveal something private about that individual.

Examples of common sensitive attributes include:
- Health conditions
- Income level
- Religion, ethnicity
- Sexual orientation
- Online behavior
- Food choices that imply lifestyle, health, or cultural background

## PII vs Quasi-Identifiers vs Sensitive Attributes Summary

**Personally Identifiable Information (PII) Definition**:\
Data that directly and uniquely identifies a specific person without needing any additional information.

**Quasi-identifiers Definition**:\
Attributes that do not identify a person by themselves,
but can identify someone when combined with other attributes or external data sources.

**Sensitive Attributes Definition**:\
Attributes that reveal private, personal, or potentially harmful information about someone —
even if they do not identify the person directly.

| Category                 | Identifies person?         | Reveals private info? | Examples                                |
| ------------------------ | -------------------------- | --------------------- | --------------------------------------- |
| **PII**                  | Yes (directly)             | Sometimes             | Name, email, phone                      |
| **Quasi-identifiers**    | Indirectly (when combined) | Not necessarily       | Age, ZIP, gender                        |
| **Sensitive attributes** | No                         | Yes                   | Health data, meal type, viewing history |



### Data anonymization versus Data utility
There is always a tension between:
- **Privacy:** Reducing re-identification risks.
- **Utility:** Keeping the data useful for analysis.

Stronger anonymization → safer but less useful.  
Many anonymization frameworks aim to balance this trade-off.

## Alogritmes for structured data

### k-Anonymity
A dataset is *k-anonymous* if every combination of quasi-identifiers appears in at least **k records**.

**Strengths**
- Intuitive and widely used.
- Useful basic protection.

**Weaknesses**
- Vulnerable to *background knowledge attacks*.
- Vulnerable to *homogeneity attacks* when sensitive attributes have little variation within groups.

### ℓ-Diversity
ℓ-Diversity extends k-anonymity.  
Each k-group must contain at least **ℓ distinct values** of the sensitive attribute.

**Strengths**
- Mitigates homogeneity attacks.

**Weaknesses**
- Not applicable when sensitive attributes inherently lack diversity.
- Harder to guarantee in small datasets.

### t-Closeness
t-Closeness requires that the distribution of sensitive values within each group is close to the distribution of the entire dataset, within a threshold **t**.

**Strengths**
- Protects against inference attacks.
- Respects semantic distance.

**Weaknesses**
- More complex to compute.
- Requires statistical distance measures.

## Explaining k-Anonymity

Context: \
You work for a streaming platform that collects viewing data from its users.
Before sharing this data with an external research partner, you must anonymize it so that no individual user can be re-identified.


| User ID | Age | ZIP Code | Device ID   | Movie Title        | Timestamp           |
|---------|-----|----------|-------------|--------------------|---------------------|
| 10012   | 22  | 3012AB   | ANDR-928123 | Guardians of Time  | 2025-01-17 19:22    |
| 10055   | 23  | 3012AC   | IPHN-551822 | Guardians of Time  | 2025-01-17 21:10    |
| 10077   | 24  | 3012AD   | ANDR-552211 | Guardians of Time  | 2025-01-17 22:03    |
| 10111   | 31  | 3015GD   | SMRTV-882133| Deep Blue City     | 2025-01-18 09:44    |
| 10145   | 33  | 3015GE   | SMRTV-882133| Deep Blue City     | 2025-01-18 12:17    |
| 10201   | 46  | 3013BB   | TABL-992381 | Moonfall Drift     | 2025-01-18 20:05    |
| 10207   | 47  | 3013BC   | IPAD-318882 | Moonfall Drift     | 2025-01-18 20:11    |


🧠 Your job: transform the dataset so that every combination of quasi-identifiers appears at least 2 times.

<details><summary>Click to reveal a solution</summary>

| Age (range) | ZIP (4-digit) | Device Type   | Movie Title       | Date       |
| ----------- | ------------- | ------------- | ----------------- | ---------- |
| 20–29       | 3012          | Mobile        | Guardians of Time | 2025-01-17 |
| 20–29       | 3012          | Mobile        | Guardians of Time | 2025-01-17 |
| 20–29       | 3012          | Mobile        | Guardians of Time | 2025-01-17 |
| 30–39       | 3015          | Smart TV      | Deep Blue City    | 2025-01-18 |
| 30–39       | 3015          | Smart TV      | Deep Blue City    | 2025-01-18 |
| 45–49       | 3013          | Mobile/Tablet | Moonfall Drift    | 2025-01-18 |
| 45–49       | 3013          | Mobile/Tablet | Moonfall Drift    | 2025-01-18 |

Why this satisfies k=2 anonymity:

- Every combination appears at least twice
- The first group (Guardians of Time) appears three times, showing that k = 2 is a minimum requirement — groups may be larger than 2.

</details>

## Excercise - Background Knowledge Attack on a k-Anonymous QuickEats Dataset

QuickEats is a meal-delivery service and we received this k-Anoymous dataset for further analisys.

Anonymized Dataset (k = 2)

| ZIP Prefix | Order Time | Device Type | Price Range | Meal Type          |
|------------|------------|--------------|-------------|---------------------|
| 3012       | Evening    | Mobile       | €20–€29     | Vegan Salad         |
| 3012       | Evening    | Mobile       | €20–€29     | BBQ Meat Feast      |
| 3012       | Evening    | Mobile       | €20–€29     | Thai Green Curry    |
| 3012       | Afternoon  | Mobile       | €10–€19     | Chicken Wrap        |
| 3012       | Afternoon  | Mobile       | €10–€19     | Vegan Poke Bowl     |
| 3015       | Evening    | Laptop       | €20–€29     | Pasta Alfredo       |
| 3015       | Evening    | Laptop       | €20–€29     | Four Cheese Pizza   |
| 3015       | Afternoon  | Laptop       | €10–€19     | Spicy Ramen         |
| 3015       | Afternoon  | Laptop       | €10–€19     | Tomato Soup         |


This dataset satisfies k = 2 because every combination of quasi-identifiers
(ZIP Prefix, Order Time, Device Type, Price Range) appears at least twice.

- Sensitive attribute = Meal Type

In this exercise, Meal Type is considered a sensitive attribute because:

- Certain food choices can reveal health conditions (e.g., allergies, dietary restrictions).
- Food patterns may imply religious preferences (e.g., halal, kosher).
- Some meals reflect lifestyle or ethical beliefs (e.g., veganism).

*Attack Scenario*\
An attacker, Mila, wants to find out what her colleague Tom ordered yesterday from QuickEats.
Mila knows the following background information:
- Tom lives in ZIP area 3012
- Tom mentioned he spent “about 25 euros”
- Tom is allergic to peanuts, and avoids all Thai dishes
- He is trying to cut down on meat, but “sometimes still eats meat if nothing else is available”

Based on the anonymized table and Mila’s background knowledge, which meal did Tom most likely order?

<details><summary>Click to reveal the answer</summary>

Tom must be in this equivalence class:

ZIP 3012, €20–€29 → rows 1, 2, 3

So the candidate meals are:
- Vegan Salad
- BBQ Meat Feast
- Thai Green Curry

Apply background knowledge:
1. Tom is allergic to peanuts → Thai dishes often contain peanuts → eliminate Thai Green Curry
2. Tom tries to cut down on meat, but still eats it occasionally → “BBQ Meat Feast” is possible, but less likely
3. If a vegan option exists, Tom usually prefers that → strongest candidate = Vegan Salad

Attack Result\
Mila cannot be 100% certain, but can infer with high confidence that Tom ordered: Vegan salad.

This is a classic background knowledge attack. Even though the dataset is k-anonymous, external knowledge collapses the attacker’s uncertainty.
</details>

## Explaining ℓ-Diversity

Context\
A hospital wants to publish anonymous data about patient visits for research purposes.

Quasi-identifiers:\
Age range, ZIP code prefix, Gender\
\
Sensitive attribute:\
Medical Condition

We want to anonymize the data so that no one can determine a patient’s condition from the anonymized dataset.

**Anonymized Dataset (after k-anonymity)**\
The hospital has already applied k = 3 anonymity. Here is the resulting table:

| Age Range | ZIP | Gender | Medical Condition |
|-----------|------|--------|-------------------|
| 30–39     | 3012 | F      | Depression        |
| 30–39     | 3012 | F      | Anxiety           |
| 30–39     | 3012 | F      | Migraine          |
| 40–49     | 3012 | M      | Hypertension      |
| 40–49     | 3012 | M      | Hypertension      |
| 40–49     | 3012 | M      | Hypertension      |

The quasi-identifiers form two groups:

1) Group A — 30–39, 3012, Female
    Medical conditions in the group:
    - Depression
    - Anxiety
    - Migraine

2) Group B — 40–49, 3012, Male
    Medical conditions in the group:
    - Hypertension
    - Hypertension
    - Hypertension

**Apply the ℓ-Diversity Definition** \
ℓ-Diversity requires: *Each group must contain at least ℓ distinct values of the sensitive attribute.* \
Now we check both groups.

If ℓ = 1
\
    - Group A: 3 values → OK \
    - Group B: 1 value → OK \
    → Dataset is 1-diverse
    (but this is equivalent to no protection at all against attribute disclosure)

If ℓ = 2
\
    - Group A: 3 values → OK \
    - Group B: 1 value → FAIL \
    → Dataset is not 2-diverse

If ℓ = 3
\
    - Group A: 3 values → OK \
    - Group B: 1 value → FAIL \
    → Dataset is not 3-diverse

**Homogenity attack**\
***"Every man aged 40–49 in ZIP area 3012 who visited the clinic has Hypertension.”***\
Or put differently:
***“If I know that John (male, 47, 3012) went to this clinic, I immediately know exactly which medical condition he has.”***

**Excercise**

The equivalence class *(Age 40–49, ZIP 3012, Male)* contains only one sensitive value: *Hypertension*.\
This group satisfies k = 3 but fails ℓ-diversity for any ℓ ≥ 2.

🧠 How can we fix this problem in the dataset so that it satisfies ℓ-diversity?

<details><summary>Click to reveal a solution</summary>
Because the group has only one sensitive attribute value, it is impossible to satisfy ℓ-diversity without modifying the dataset.

\
Two theoretical options exist:
1) Increase the diversity of the sensitive attribute (e.g., split “Hypertension” into medically meaningful subcategories)

2) Suppress or merge the entire equivalence class (e.g., broaden age range or ZIP prefix)

If neither option is realistic, ℓ-diversity cannot be achieved for this group.
</details>

## Explaining t-Closeness

- k-Anonymity protects identity.
- ℓ-Diversity protects sensitive attribute variety.

But both still fail when:\
The distribution of sensitive values inside a group is very different from the distribution in the whole dataset. In that case, an attacker can still make high-confidence guesses.

**t-Closeness Definition**: 
A group satisfies t-closeness if:
The distance between the sensitive attribute distribution of the group and the overall distribution of the dataset is less than a threshold t.

The concept is that the group distribution should look similar to the global distribution.

*Compute the global distribution*

First, compute the global distribution of medical conditions.
Let’s assume the full dataset contains:
Global distribution:
- Depression:    70%
- Anxiety:       10%
- Migraine:      15%
- Hypertension:   5%

*Check group A*

*Group A — Age 30–39, 3012, Female*\
Values:
- Depression
- Anxiety
- Migraine

\
So the group distribution is:
- Depression: 33%
- Anxiety:    33%
- Migraine:   33%
- Hypertension: 0%


Difference from global distribution: Hughe distance. Does not satisfy t-closeness for reasonable t.


*Skewness Attack Scenario*

This attack occurs when the global distribution of the sensitive attribute is very skewed.

For this dataset an attacker can:
- eliminate the probability of Hypertension
- cut the probability of Depression in half
- triple the probability of Anxiety
- more than double the probability of Migraine

Why is this a problem?
Because the attacker learns far more than they should. The privacy leak is not an exact diagnosis, but a shift in probabilities.

This still counts as a privacy breach: “Even if I don’t know exactly what Emma has, I can compute much better probabilities than I should be able to.”

**t-closeness cannot 'fix' the data**

t-Closeness is a diagnostic test, not a cure — it tells you when a subgroup reveals too much information, but the only way to fix it is to merge, suppress, or generalize the data.

## t-Closeness Exercise — AOL Search Query Leak (2006)

## Background of the Real Incident

In 2006, AOL released “anonymized” search logs from 650,000 users for research purposes. All personally identifiable information (PII) was removed, and users were replaced by random numeric IDs.

However, many subsets of users had **highly skewed sensitive-value distributions**, which allowed attackers to infer sensitive information such as:

- medical problems  
- religious belief  
- political preference  
- sexual orientation  
- mental health issues  
- family conflicts  
- addictions  
- legal trouble  

One user, *AOL User 4417749*, was deanonymized by journalists **purely through the pattern of her searches**.

This became a landmark example of **t-closeness failure**.

---

## Simplified Global Distribution

Assume the global search distribution looks like this:

- General topics:        70%  
- Medical topics:        10%  
- Religion topics:        5%  
- Legal/Justice topics:   5%  
- Relationship issues:   10%

This represents what an attacker *should* believe before looking at any subgroups.

---

## Equivalence Class (Anonymized Subgroup for the Exercise)

Below is an anonymized subset from users who share the same quasi-identifiers  
(Age, ZIP, Device, Time of day):

| Age Range | ZIP  | Device  | Time of Day | Query Category      |
|-----------|------|----------|-------------|---------------------|
| 50–59     | 3004 | Desktop  | Evening     | Religion            |
| 50–59     | 3004 | Desktop  | Evening     | Religion            |
| 50–59     | 3004 | Desktop  | Evening     | Religion            |
| 50–59     | 3004 | Desktop  | Evening     | Religion            |
| 50–59     | 3004 | Desktop  | Evening     | Medical             |
| 50–59     | 3004 | Desktop  | Evening     | Relationship Issue  |


### Group Distribution:
- Religion: 66%  
- Medical: 17%  
- Relationship: 17%  
- General: 0%  
- Legal: 0%

---

## Comparison: Global vs. Group Distribution

### Global distribution:
- Religion: 5%  
- Medical: 10%  
- Relationship: 10%

### Group A distribution:
- Religion: **66%**  
- Medical: **17%**  
- Relationship: **17%**


## Questions

🧠 1. Does this group satisfy k-anonymity? Why or why not?  

<details><summary>Click to reveal answer</summary>
Yes — the group has 6 records → k = 6.
</details>

\
🧠 2. Does this group satisfy ℓ-diversity? What is ℓ?  
<details><summary>Click to reveal answer</summary>
Yes — 3 distinct values → ℓ = 3.
</details>

\
🧠 Does this group satisfy t-closeness? Explain.
<details><summary>Click to reveal answer</summary>
No — the distribution differs dramatically from the global distribution, especially Religion (5% → 66%).
</details>

\
🧠 What sensitive information can an attacker infer?  
<details><summary>Click to reveal answer</summary>
The user is very likely religious; may be dealing with medical or relationship issues.
</details>

\
🧠 Why is this a privacy breach even if the identity is unknown?
<details><summary>Click to reveal anser</summary>
Even without identity disclosure, the attacker learns far more about the user than allowed.  
This is sensitive attribute disclosure through probabilistic inference.
</details>



