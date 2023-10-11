#ifndef HTTPUTIL_H
#define HTTPUTIL_H

#include <QObject>
#include <qnetworkreply.h>
#include <QNetworkAccessManager>

class HttpUtil : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtil(QObject *parent = nullptr);
    ~HttpUtil();

    Q_INVOKABLE void httpConnect(QString url);
    Q_INVOKABLE void replyFinished(QNetworkReply *reply);

signals:
    void replySignal(QString reply);
private:
    QNetworkAccessManager *manager_;
    QString url_ = "http://47.108.156.22:3000/";
};

#endif // HTTPUTIL_H
