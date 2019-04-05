DIR=$1
FILE=$DIR/index.html
cat $FILE | \
#sed 's@\.\./\.\./@\.\./\.\./\.\./@g' | \
#sed 's@a class="nav-link" href="@a class="nav-link" href="../@g' | \
#sed 's@submissions@../submissions@g' | \
sed 's@submissions\?@submissions_@g' > $DIR/index2.html
mv $DIR/index2.html $DIR/index.html