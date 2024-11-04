# Script to create a mapping between various identifiers for the same pokemon

import requests
import json

print("Obtaining pokemon identifiers...")

# Grab total number of pokemon species to iterate over
pokemon_species_endpoint_limited = "https://pokeapi.co/api/v2/pokemon-species"
pokemon_species_response_limited = requests.get(pokemon_species_endpoint_limited)
pokemon_species_response_limited_json = pokemon_species_response_limited.json()
pokemon_species_count = pokemon_species_response_limited_json['count']

# Get all pokemon species
pokemon_species_endpoint = "https://pokeapi.co/api/v2/pokemon-species?limit=" + str(pokemon_species_count)
pokemon_species_response = requests.get(pokemon_species_endpoint)
pokemon_species_response_json = pokemon_species_response.json()
pokemon_species_results = pokemon_species_response_json['results']

# For each pokemon species, grab all identifiable names
pokemon_identifiers = {}
for pokemon_species_result_idx in range(pokemon_species_count):

    # Obtain each species' response
    pokemon_species_idx_endpoint = pokemon_species_results[pokemon_species_result_idx]['url']
    pokemon_species_idx_response = requests.get(pokemon_species_idx_endpoint)
    pokemon_species_idx_response_json = pokemon_species_idx_response.json()

    # Grab the canonical name for each pokemon species
    pokemon_species_idx_name = pokemon_species_idx_response_json['name']

    # Grab the id for each pokemon species
    pokemon_species_idx_id = pokemon_species_idx_response_json['id']

    # TODO: format this with indentation and overwriting the previous line
    print(str(pokemon_species_result_idx) + ": " + pokemon_species_idx_name)

    # Add the id as an identifier
    pokemon_identifiers |= {pokemon_species_idx_id: pokemon_species_idx_name}

    # Add the canonical name as an identifier
    pokemon_identifiers |= {pokemon_species_idx_name: pokemon_species_idx_name}

    # Grab the localized names for each pokemon species
    pokemon_species_idx_names = pokemon_species_idx_response_json['names'][:-1]
    # The last entry is not a name, hence the `[:-1]`
    names = pokemon_species_idx_names[:-1]
    for name_idx in range(len(names)):
        name = pokemon_species_idx_names[name_idx]['name']
        name = name.casefold()
        pokemon_identifiers |= {name: pokemon_species_idx_name}

# TODO get localized form names: once done add to readme
# Example response: https://pokeapi.co/api/v2/pokemon-form/arceus-fairy
# Resources: https://github.com/PokeAPI/pokeapi/blob/f3fd16c59edf9defab8be3c24f43cd768747199b/data/v2/csv/pokemon_form_names.csv
# The only place where complete form names are localized: https://www.pokeos.com/pokedex/585-autumn
# For forms may have to massage them ourselves i.e. <japanese-pokemon-name>-<japanese-form-name>
# where the arguments can be requested from the endpoints,
# but being careful that the translated word of "form" doesn't show up
# i.e. canonical name: deerling-autumn, jp name: シキジカ-はる (i.e. deerling-autumn) instead of "シキジカ-はるのすがた" (i.e. deerling-autumnform
pokemon_identifiers |= {"シキジカ-あき": "deerling-autumn"}

print("Obtained pokemon identifiers.")

with open("../share/pokemon_identifiers.json", "w") as json_file:
    json.dump(pokemon_identifiers, json_file, ensure_ascii = False, indent = 2)
