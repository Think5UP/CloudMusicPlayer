#include "httputil.h"

HttpUtil::HttpUtil(QObject *parent)
    : QObject{parent}
    , manager_(new QNetworkAccessManager(this))
{
    connect(manager_, SIGNAL(finished(QNetworkReply *)), this, SLOT(replyFinished(QNetworkReply *)));
}

HttpUtil::~HttpUtil()
{
    delete manager_;
}

void HttpUtil::httpConnect(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(url_ + url));
    manager_->get(request);
}

void HttpUtil::replyFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll());
}
