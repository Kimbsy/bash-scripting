#!/bin/bash
#
# Monitor the changes in price of a list of Magic: The Gathering cards.

#******************************************************************************#
# Replace spaces with '+' characters for  URL and price data file name.
#******************************************************************************#
url_encode() {
    echo ${1// /+}
}

#******************************************************************************#
# Construct appropriate MTGGoldfish URL.
#******************************************************************************#
get_url() {
    echo "https://www.mtggoldfish.com/price/$(url_encode "$1")/$(url_encode "$2")"
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
    file_name="price_data/$(url_encode "$1")--$(url_encode "$2")"

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
    echo "$1 price:"
    echo "$2"
    echo ""
}


while read -r card_line; do
    # Split the card line into set name and card name.
    IFS=';' read -r -a details <<< "$card_line"
    set_name=${details[0]}
    card_name=${details[1]}

    price=$(get_price "$set_name" "$card_name")
    save_price "$set_name" "$card_name" "$price"

    print_card_price "$card_name" "$price"
done < watch_list


