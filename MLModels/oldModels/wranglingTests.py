----------------------------------------------------------------------------------------------------------------
# Convert strings to lowercase and remove leading/trailing whitespaces
games['subgenres'] = games['subgenres'].str.lower().str.strip()

# Define a dictionary to map subgenres to the specified list
subgenre_mapping = {
    'first-person shooter': 'First-person shooter (FPS)',
    'action role-playing': 'Action Role-Playing',
    'management simulation': 'Construction and management simulation (CMS)',
    'action platformer': 'Platformer',
    'role-playing': 'Role-playing (RPG)',
    'survival': 'Survival',
    'city-building': 'Construction and management simulation (CMS)',
    'action-adventure': 'Action-Adventure',
    'action': 'Action',
    'stealth': 'Stealth',
    'art game': 'Other',
    'survival horror': 'Survival horror',
    'third-person shooter': 'Tactical shooter',
    'tactical shooter': 'Tactical shooter',
    'turn-based tactical': 'Strategy',
    'rpg': 'Role-playing (RPG)',
    'strategy': 'Strategy',
    'space trading and combat': 'Simulation',
    'hack and slash': 'Hack and slash',
    'simulation': 'Simulation',
    'mmorpg': 'Massively multiplayer online (MMO)',
    'platform-adventure': 'Action-Adventure',
    'platform': 'Platformer',
    'adventure': 'Adventure',
    'puzzle': 'Puzzle',
    'metroidvania': 'Action-Adventure',
    'platformer': 'Platformer',
    'brawler': 'Fighting',
    'real-time tactics': 'Strategy',
    'turn-based strategy': 'Strategy',
    'real-time strategy': 'Real-time strategy (RTS)',
    'tactical role-playing': 'Tactical shooter',
    "shoot 'em up": "Other",
    'space simulation': 'Simulation',
    'massively multiplayer online role-playing game': 'Massively multiplayer online (MMO)',
    'social simulation': 'Simulation',
    'battle royale': 'Battle royale',
    'collectible card tower defense': 'Tower defense',
    'vehicle simulation game': 'Simulation',
    'sandbox': 'Sandbox',
    'rhythm': 'Other',
    'top-down shooter': 'Point-and-click',
    'shooter': 'First-person shooter (FPS)',
    'music': 'Other',
    'visual novel': 'Visual novel',
    'roguelike': 'Roguelike',
    'fighting': 'Fighting',
    'immersive sim': 'Simulation',
    'graphic adventure': 'Adventure',
    'dungeon crawl': 'Other',
    'management': 'Construction and management simulation (CMS)',
    'tower defense': 'Tower defense',
    'air combat simulation': 'Simulation',
    'vehicular combat': 'Other',
    'racing': 'Racing',
    'puzzle-platform': 'Puzzle',
    'survival game': 'Survival',
    'comedy': 'Other',
    'real-time strategy and real-time tactics': 'Strategy',
    'bullet hell': 'Other',
    'exploration': 'Other',
    'construction and management simulation': 'Construction and management simulation (CMS)',
    'life simulation': 'Simulation',
    'first-person hero shooter': 'First-person shooter (FPS)',
    'sandbox survival': 'Survival',
    'action adventure': 'Action-Adventure',
    'space combat': 'Simulation',
    'escape the room': 'Other',
    'first-person shooterthird-person shooterhack and slash': 'First-person shooter (FPS)',
    'business simulation': 'Construction and management simulation (CMS)',
    'match-three': 'Puzzle',
    'extreme sports': 'Sports',
    '4x': 'Strategy',
    'sports': 'Sports',
    'point and click adventure': 'Point-and-click',
    'sport simulations': 'Sports',
    'party': 'Other',
    'multidirectional shooter': 'Other',
    'nakige': 'Other',
    'dating sim': 'Other',
    'otome': 'Other',
    'scrolling shooter': 'Point-and-click',
    'platformingtower defense': 'Tower defense',
    'moba': 'Massively multiplayer online (MMO)',
    'point-and-click adventure': 'Point-and-click',
    'digital collectible card game': 'Card game',
    'interactive fiction': 'Interactive fiction',
    'combat flight simulator': 'Simulation',
    'real-time tactics / strategy': 'Strategy',
    'massively multiplayer online': 'Massively multiplayer online (MMO)',
    'massively multiplayer online role-playing': 'Massively multiplayer online (MMO)',
    'space flight simulator': 'Simulation',
    'dungeon crawler': 'Other',
    'art': 'Other',
    'driving': 'Racing',
    'psychological horror': 'Survival horror',
    'first-person shooter cyberpunk': 'First-person shooter (FPS)',
    'turn-based tactics': 'Strategy',
    'hack-and-slash': 'Hack and slash',
    'action role-playing game': 'Action Role-Playing',
    'mmog': 'Massively multiplayer online (MMO)',
    'business simulation game': 'Construction and management simulation (CMS)',
    'fantasy rpg': 'Role-playing (RPG)',
    "beat 'em up": "Beat 'em up",
    'tactical role-playing game': 'Tactical shooter',
    'space trading and combat simulator': 'Simulation',
    'space flight simulation': 'Simulation',
    'interactive film': 'Other',
    'platform game': 'Platformer',
    'multiplayer online battle arena': 'Other',
    'twin-stick shooter': 'Other',
    'vehicle simulation': 'Simulation',
    'government simulation': 'Construction and management simulation (CMS)',
    'various': 'Other',
    'space combat simulator': 'Simulation',
    'amateur flight simulation': 'Simulation',
    'sporting management simulation': 'Construction and management simulation (CMS)',
    'cinematic platformer': 'Platformer',
    'hack-n-slash': 'Hack and slash',
    'multidirectional shootervehicular combat': 'Other',
    'multi-directional shooter': 'Other',
    'action-role playing': 'Action Role-Playing',
    'artillery': 'Other',
    'side scroller': 'Platformer',
    'breakout clone': 'Other',
    'interactive drama': 'Other',
    'hunting': 'Other',
    'cinematic platform': 'Platformer',
    'collectible card': 'Card game',
    'role-playingrogueliketurn-based strategy': 'Role-playing (RPG)',
    'grand strategy': 'Strategy',
    'run and gun': 'Action',
    'puzzle adventure': 'Puzzle',
    'stealth game': 'Stealth',
    'interactive drama survival horror': 'Survival horror',
    'shooting game': 'First-person shooter (FPS)',
    'snake': 'Other',
    'racing simulation': 'Racing',
    'first-person photography game': 'Other',
    'dungeon management': 'Strategy',
    'partysocial deduction': 'Other',
    'rail shooter': 'Other',
    'roguelike deck-building': 'Roguelike',
    'deck-building game': 'Other',
    'dungeon crawling': 'Other',
    'first-person shooter survival horror': 'Survival horror',
    'light gun shooter': 'Other',
    'wrestling': 'Sports',
    'god game': 'Other',
    'first-person shooterinteractive film': 'First-person shooter (FPS)',
    'match-3': 'Puzzle',
    'action role playing': 'Action Role-Playing',
    'role-playing video game': 'Role-playing (RPG)',
    'puzzle rpg': 'Puzzle',
    'graphic adventureinteractive movie': 'Graphic Adventure',
    'hero shooter': 'Other',
    'action-adventure\nplatform': 'Action-Adventure',
    'real-time strategyreal-time tactics': 'Strategy',
    'first-person shooterstealth': 'First-person shooter (FPS)',
    'third person shooter': 'Other',
    'simulation game': 'Simulation',
    'adventuresurvivalsurvival horrorrole-playing': 'Survival horror',
    'adventure game': 'Adventure',
    'first-person shootersurvival horror': 'Survival horror',
    'action-adventure game': 'Action-Adventure',
    'open world': 'Open-world',
    'multi-directional shootermetroidvania': 'Other',
    'digital board game': 'Other',
    'collectible card game': 'Card game',
    'racing management': 'Racing',
    'massively multiplayer online first-person shooter game': 'Massively multiplayer online (MMO)',
    'graphic adventure interactive movie': 'Graphic Adventure',
    'massively multiplayer online first-person shooter': 'Massively multiplayer online (MMO)',
    'side-scrolling': 'Platformer',
    'political simulation': 'Construction and management simulation (CMS)',
    'psychological thriller': 'Other',
    'indie': 'Other',
    'role-playing shooter': 'Action Role-Playing',
    'sport   first-person shooter': 'Sports',
    np.nan: 'Other',
    'graphic adventure game': 'Graphic Adventure',
    'exploration game': 'Other',
    'action-adventureshooter': 'Action',
    'first-person rail shooterphotography game': 'Other',
    'truck simulator': 'Simulation',
    'third-person shooterhero shooter': 'Other',
    'sports simulation': 'Sports',
    'hero shooter tactical shooter': 'Other',
    'sports management': 'Sports',
    'digital pet': 'Other',
    'strategy game': 'Strategy',
    'submarine simulator': 'Simulation',
    'mmo/vehicular combat game/tps': 'Other',
    'roguelite': 'Roguelike',
    'point-and-click adventureinteractive fiction': 'Point-and-click',
    'card battle': 'Card game',
    'aerial combat': 'Other',
    'adventure/puzzle': 'Adventure',
}

# Map subgenres to the specified genres and label unmatched genres as "Other"
games['subgenres'] = games['subgenres'].map(subgenre_mapping).fillna('Other')

# Print the unique genres after mapping
print(games['subgenres'].unique())
print(games['subgenres'].nunique())


games.to_csv("genresTest.csv", index=False)

----------------------------------------------------------------------------------------------------------------

## NLP Engineering

The code block contains a function and several operations to preprocess the 'description' column in the modelDs DataFrame. The preprocess_description() function converts the text to lowercase, removes non-alphabetic characters and strings shorter than 3 characters, and eliminates stop words using the NLTK library. The function is applied to the 'description' column using the apply() method, and the preprocessed descriptions are stored in a new column called 'processed_description'. The preprocessed descriptions are then transformed into dummy variables using pd.get_dummies(), and the resulting dummy variables are concatenated with the original DataFrame. The original 'description' and 'processed_description' columns are dropped. Next, the preprocessed descriptions are tokenized into individual words, and lemmatization is performed using the WordNetLemmatizer from NLTK. The code counts the occurrences of each word, retrieves the most common words, and prints them. Additionally, the code retrieves the 25 unique words that occur rarely and prints them. This preprocessing and word analysis is useful for text-based analysis or natural language processing tasks.


## THIS RUNS DUMMY COLUMNS FOR ALL THE WORDS THAT WERE LEMMATIZED (RUN EVERYTHING ABOVE BEFORE RUNNING THIS ONE OR THE SECOND VERSION BELOW)
```{python}
# Function to preprocess the description column
def preprocess_description(description):
    # Convert to lowercase
    description = description.lower()
    
    # Remove non-alphabetic characters and strings shorter than 3 characters
    description = re.sub(r'[^a-z ]', '', description)
    description = ' '.join(word for word in description.split() if len(word) > 2)
    
    # Remove stop words
    stop_words = set(stopwords.words('english'))
    description = ' '.join(word for word in description.split() if word not in stop_words)
    
    return description

# Apply preprocessing to the description column
modelDs['processed_description'] = modelDs['description'].apply(preprocess_description)

# Convert the processed description into dummy variables
dummy_cols = pd.get_dummies(modelDs['processed_description'], prefix='description', drop_first=True)
modelDs = pd.concat([modelDs, dummy_cols], axis=1)

# Drop the original description and processed_description columns
modelDs.drop(['description', 'processed_description'], axis=1, inplace=True)

# Tokenize the preprocessed descriptions into individual words and perform lemmatization
all_words = ' '.join(modelDs.columns.tolist())
word_tokens = all_words.split()

lemmatizer = WordNetLemmatizer()
lemmatized_words = [lemmatizer.lemmatize(word) for word in word_tokens]

# Count the occurrences of each word
word_counts = Counter(lemmatized_words)

# Retrieve the most common words
most_common_words = word_counts.most_common(25)  # Change the number 25 to get a different number of most common words

print("Most common words:")
for word, count in most_common_words:
    print(f"{word}: {count}")

# Retrieve the 25 unique words that occur rarely
rare_words = [word for word, count in word_counts.items() if count == 1][:25]

print("Rarely occurring words:")
for word in rare_words:
    print(word)
```

