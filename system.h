#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>
#include <stdlib.h>

class Exec:public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void system_monitor(){
        system("deepin-system-monitor &");
    }
};

#endif // SYSTEM_H
