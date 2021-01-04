/*
 * harbour-watchlist - Sailfish OS Version
 * Copyright © 2019 Andreas Wüst (andreas.wuest.freelancer@gmail.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/thirdparty"

import "../js/constants.js" as Constants
import "../js/database.js" as Database
import "../js/functions.js" as Functions

SilicaFlickable {
    id: stockDetailsViewFlickable

    contentHeight: stockDetailsColumn.height

    property var stock

    Column {
        id: stockDetailsColumn

        // height: childrenRect.height
        anchors {
            left: parent.left
            right: parent.right
        }

        SectionHeader {
            //: StockDetailsView page general data
            text: qsTr("General data")
        }

        LabelValueRow {
            id: currencyLabelValueRow
            //: StockDetailsView page currency
            label: qsTr("Currency")
            value: ''
        }

        LabelValueRow {
            id: isinLabelValueRow
            //: StockDetailsView page isin
            label: qsTr("Isin")
            value: ''
        }

        LabelValueRow {
            id: symbolLabelValueRow
            //: StockDetailsView page symbol
            label: qsTr("Symbol")
            value: ''
        }

        LabelValueRow {
            id: stockMarketNameLabelValueRow
            //: StockDetailsView page stock market
            label: qsTr("Stock Market")
            value: ''
        }

        SectionHeader {
            //: StockDetailsView page trading data
            text: qsTr("Trading data")
        }

        LabelValueRow {
            id: priceLabelValueRow
            //: StockDetailsView page price
            label: qsTr("Price")
            value: ''
        }

        LabelValueRow {
            id: changeAbsoluteLabelValueRow
            //: StockDetailsView page change absolute
            label: qsTr("Change abs.")
            value: ''
        }

        LabelValueRow {
            id: changeRelativeLabelValueRow
            //: StockDetailsView page change relative
            label: qsTr("Change rel.")
            value: ''
        }

        LabelValueRow {
            id: timestampLabelValueRow
            //: StockDetailsView page timestamp
            label: qsTr("Timestamp")
            value: ''
        }

        LabelValueRow {
            id: askLabelValueRow
            //: StockDetailsView page ask
            label: qsTr("Ask")
            value: ''
        }

        LabelValueRow {
            id: bidLabelValueRow
            //: StockDetailsView page bid
            label: qsTr("Bid")
            value: ''
        }

        LabelValueRow {
            id: highLabelValueRow
            //: StockDetailsView page high
            label: qsTr("High")
            value: ''
        }

        LabelValueRow {
            id: lowLabelValueRow
            //: StockDetailsView page low
            label: qsTr("Low")
            value: ''
        }

        LabelValueRow {
            id: volumeLabelValueRow
            //: StockDetailsView page volume
            label: qsTr("Volume")
            value: ''
        }

        SectionHeader {
            id: notesSectionHeader
            //: StockDetailsView page security notes
            text: qsTr("Notes")
            visible: notesRow.visible
        }

        LabelOnlyRow {
            id: notesRow
            label: ''
            visible: false;
        }

    }

    Component.onCompleted: {
        if (stock) {
            currencyLabelValueRow.value = stock.currency ? stock.currency : '';
            var currencySymbol = stock.currencySymbol;
            isinLabelValueRow.value = stock.isin ? stock.isin : '';
            symbolLabelValueRow.value = stock.symbol1 ? stock.symbol1 : ''; // TODO warum symbol1
            stockMarketNameLabelValueRow.value = stock.stockMarketName ? stock.stockMarketName : '';
            askLabelValueRow.value = Functions.renderPrice(stock.ask, currencySymbol);
            bidLabelValueRow.value = Functions.renderPrice(stock.bid, currencySymbol);
            highLabelValueRow.value = Functions.renderPrice(stock.high, currencySymbol);
            lowLabelValueRow.value = Functions.renderPrice(stock.low, currencySymbol);
            changeAbsoluteLabelValueRow.value = stock.changeAbsolute ? Functions.renderChange(stock.price, stock.changeAbsolute, currencySymbol) : '';
            changeRelativeLabelValueRow.value = stock.changeRelative ? Functions.renderChange(stock.price, stock.changeRelative, '%') : '';
            priceLabelValueRow.value = Functions.renderPrice(stock.price, currencySymbol);
            volumeLabelValueRow.value = stock.volume ? stock.volume : '';
            timestampLabelValueRow.value = stock.quoteTimestamp ? Functions.renderDateTimeString(stock.quoteTimestamp) : '';
            var notes = Database.loadStockNotes(stock.id);
            if (notes && notes !== '') {
                notesRow.label = notes;
                notesRow.visible = true;
            }
        }
    }

    VerticalScrollDecorator {
        flickable: stockDetailsViewFlickable
    }

}
