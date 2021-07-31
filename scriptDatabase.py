from firebase import firebase
# bdd de test
firebase = firebase.FirebaseApplication('http://localhost:9000/?ns=runningwith-ae2b7', None)
# firebase = firebase.FirebaseApplication('https://runningwith-ae2b7.firebaseio.com/', None)
firebase.delete('/run/', None)
run1 = {
      "address" : "Mont-De-Marsan",
      "creator" : "CZVVCG50gCdhgsQzhMkhGSKRzXp2",
      "date" : "01/02/2020",
      "duration" : 45,
      "level" : "beginner",
      "runners" : [ "CZVVCG50gCdhgsQzhMkhGSKRzXp2", "WHRzECVMUoQ0Dxq5BJ4208S0hKc2" ],
      "speed" : 9,
      "distance" : 5,
      "titre" : "Monday Run"
}
run2 = {
      "address" : "Paris",
      "creator" : "CZVVCG50gCdhgsQzhMkhGSKRzXp2",
      "date" : "23/02/2020",
      "duration" : 35,
      "level" : "intermedier",
      "runners" : [],
      "speed" : 9,
      "distance" : 8,
      "titre" : "Monday Run"
}
run3 = {
      "address" : "Bordeaux",
      "creator" : "WHRzECVMUoQ0Dxq5BJ4208S0hKc2",
      "date" : "24/02/2020",
      "duration" : 15,
      "level" : "beginner",
      "runners" : [],
      "speed" : 12,
      "distance" : 3,
      "titre" : "Monday Run"
}
result = firebase.post('/run/', run1)
print(result)
result = firebase.post('/run/', run2)
print(result)
result = firebase.post('/run/', run3)
print(result)
