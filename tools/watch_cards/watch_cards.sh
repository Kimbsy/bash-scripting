#!/bin/bash
#
# Monitor the changes in price of a list of Magic: The Gathering cards.

url_encode() {
    echo ${1// /+}
}

get_url() {
    echo "https://www.mtggoldfish.com/price/$(url_encode "$1")/$(url_encode "$2")"
}

get_paper_price_box() {
    curl -s $(get_url "$1" "$2") | grep -m2 'price-box-price' | tail -n1
}

get_price() {
    price_box=$(get_paper_price_box "$1" "$2")
    trim_front="${price_box##<div class=\'price-box-price\'>}"
    trimmed="${trim_front%%<*}"
    echo $trimmed
}

print_card_price() {
    echo "$2 price:"
    get_price "$1" "$2"
}

# @TODO: get cards and sets from watch_list

set_name="Khans of Tarkir"
card_name="Flooded Strand"

set_name="Ravnica City of Guilds"
card_name="Glimpse the Unthinkable"

print_card_price "$set_name" "$card_name"

# @TODO: save max/min/rolling_average prices for each card
