#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams")"
cat games.csv | while IFS="," read  YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR != 'year' ]]
then

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# if the winner is not in the table
if [[ -z $WINNER_ID ]]
  then
  # insert the winner
    INSERT_WINNER=$($PSQL "INSERT INTO teams (name) values('$WINNER')")
    if [[ $INSERT_WINNER = "INSERT 0 1" ]]
    then
      echo $WINNER inserted into teams!
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi

# get id opponent
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# if the opponent is not in the table
if [[ -z $OPPONENT_ID ]]
  then
  # insert the opponent
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams (name) values('$OPPONENT')")
    if [[ $INSERT_OPPONENT = "INSERT 0 1" ]]
    then
      echo $OPPONENT inserted into teams!
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi

  # now I have the winner_id and the opponent_id to insert into into games
  INSERT_GAME=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_GAME = "INSERT 0 1" ]]
  then
    echo Game inserted into games!
  fi

fi
done