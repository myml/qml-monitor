#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>
#include <QWindow>
#include <stdlib.h>

class Exec:public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void startSystemMove(QWindow* win){
        if (win) win->startSystemMove();
    }
    Q_INVOKABLE void system_monitor(){
        system("deepin-system-monitor &");
    }
};

#endif // SYSTEM_H
