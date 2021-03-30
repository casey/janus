run task:
    @PL=`echo {{task}}|cut -d / -f1`; \
    TASK=`echo {{task}}|cut -d / -f2`; \
    cd $PL; \
    just run $TASK < ../input/$TASK.txt;
