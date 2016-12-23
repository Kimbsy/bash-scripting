#!/bin/bash
#
# Monitor the changes in price of a list of Magic: The Gathering cards.

#******************************************************************************#
# Replace spaces with '+' characters for  URL and price data file name.
#******************************************************************************#
encode() {
    echo ${1// /+}
}

#******************************************************************************#
# Construct appropriate MTGGoldfish URL.
#******************************************************************************#
get_url() {
    echo "https://www.mtggoldfish.com/price/$(encode "$1")/$(encode "$2")"
}

#******************************************************************************#
# Grab the paper price containing div with curl.
#******************************************************************************#
get_paper_price_box() {
    curl -s $(get_url "$1" "$2") | grep -m2 'price-box-price' | tail -n1
}

#******************************************************************************#
# Extract the price from the HTML.
#******************************************************************************#
get_price() {
    price_box=$(get_paper_price_box "$1" "$2")
    trim_front="${price_box##<div class=\'price-box-price\'>}"
    trimmed="${trim_front%%<*}"
    echo $trimmed
}

#******************************************************************************#
# Check for new min/max prices and save them.
#******************************************************************************#
save_price() {
    current_price=$3
    file_name="price_data/$(encode "$1")--$(encode "$2")"

    # If this is a new card, the current price is min and max.
    if [ ! -f "$file_name" ]; then
        echo "$current_price;$current_price" > "$file_name"
        return
    fi

    # Get min and max prices from file.
    IFS=';' read -r -a min_max_prices <<< $(cat $file_name)
    min_price="${min_max_prices[0]}"
    max_price="${min_max_prices[1]}"

    # Float string comparison to determine new min/max.
    if (( $(echo "$current_price > $max_price" | bc -l) )); then
        max_price="$current_price"
    fi
    if (( $(echo "$current_price < $min_price" | bc -l) )); then
        min_price="$current_price"
    fi

    echo "$min_price;$max_price" > "$file_name"
}

#******************************************************************************#
# Print the card price details.
#******************************************************************************#
print_card_price() {
    NC='\033[0m'
    RED='\033[0;31m'
    GREEN='\033[0;32m'

    cur_c=$NC
    min_c=$GREEN
    max_c=$RED

    # Get min and max prices from file.
    IFS=';' read -r -a min_max_prices <<< $(cat $file_name)
    min_price="${min_max_prices[0]}"
    max_price="${min_max_prices[1]}"

    # Float string comparison to determine new colours.
    if (( $(echo "$current_price == $max_price" | bc -l) )); then
        cur_c=$RED
    fi
    if (( $(echo "$current_price == $min_price" | bc -l) )); then
        cur_c=$GREEN
    fi
    if (( $(echo "$min_price == $max_price" | bc -l) )); then
        max_c=$GREEN
    fi

    echo "$2 price:"
    printf "    ${cur_c}$3${NC}\n"
    printf "MIN ${min_c}$min_price${NC}\n"
    printf "MAX ${max_c}$max_price${NC}\n\n"
}




while read -r card_line; do
    IFS=';' read -r -a details <<< "$card_line"
    set_name=${details[0]}
    card_name=${details[1]}

    price=$(get_price "$set_name" "$card_name")
    save_price "$set_name" "$card_name" "$price"

    print_card_price "$set_name" "$card_name" "$price"
done < watch_list
