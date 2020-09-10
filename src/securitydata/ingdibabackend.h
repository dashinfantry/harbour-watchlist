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
#ifndef INGDIBABACKEND_H
#define INGDIBABACKEND_H

#include "abstractdatabackend.h"

#include <QObject>
#include <QNetworkReply>
#include <QNetworkAccessManager>

// TODO FIX URLS
const char ING_DIBA_API_SEARCH[] = "https://api.wertpapiere.ing.de/suche-autocomplete/autocomplete?query=%1";
const char ING_DIBA_API_QUOTE[] = "https://component-api.wertpapiere.ing.de/api/v1/components/instrumentheader/%1";
// can fetch max 100 entries at a time - so about a quarter
const char ING_DIBA_API_CLOSE_PRICES[] = "https://iss.moex.com/iss/history/engines/stock/markets/shares/boards/TQBR/securities/%1.json?from=%2%3";


// https://component-api.wertpapiere.ing.de/api/v1/components/instrumentheader/DE0005093108
// https://component-api.wertpapiere.ing.de/api/v1/components/instrumentheader/NL0012169213

class IngDibaBackend : public AbstractDataBackend {
    Q_OBJECT
public:
    explicit IngDibaBackend(QNetworkAccessManager *manager, QObject *parent = nullptr);
    ~IngDibaBackend() override;
    Q_INVOKABLE void searchName(const QString &searchString) override;
    Q_INVOKABLE void searchQuote(const QString &searchString) override;
    Q_INVOKABLE void fetchPricesForChart(const QString &extRefId, const int chartType) override;
    Q_INVOKABLE bool isChartTypeSupported(const int chartType) override;

signals:

protected:
    QString convertCurrency(const QString &currencyString) override;

public slots:

private:

    int numberOfRequestedIbans = 0;
    QList<QJsonObject> searchQuoteResults;
    QList<QString> searchQuoteErrors;

    QJsonObject processQuoteResultSingle(QByteArray searchQuoteReply);
    QJsonObject findValueFromJsonArray(QJsonArray arr, QString key, QString value);

    // is triggered after name search because the first json request does not contain all information we need
    void searchQuoteForNameSearch(const QString &searchString);
    QString processSearchResult(QByteArray searchReply);
    QString processQuoteResult(QByteArray searchReply);
    QString parsePriceResponse(QByteArray priceReply);

    QDateTime convertUTCDateTimeToLocalDateTime(const QString utcDateTimeString);

private slots:
    void handleSearchNameFinished();
    void handleSearchQuoteForNameFinished();
    void handleSearchQuoteFinished();
    void handleFetchPricesForChartFinished();
};

#endif // INGDIBABACKEND_H