import 'dart:async';
import 'dart:core';
import 'dart:html';

dynamic learnedItem;
dynamic mainItem;
dynamic startButton;
dynamic stopButton;

dynamic stopWatchHours;
dynamic stopWatchMinutes;
dynamic stopWatchSeconds;
dynamic timer;
Map itemWithTime = {};
dynamic history;
void main() {
  bindElements();
  attachEventHandlers();
  checkLocalStorage();
}

void bindElements() {
  learnedItem = querySelector('#item-input');
  mainItem = querySelector('#main-item');
  startButton = querySelector('#start');
  stopButton = querySelector('#stop');
  history = querySelector('#history');
  stopWatchHours = querySelector('#stopwatch_hours');
  stopWatchMinutes = querySelector('#stopwatch_minutes');
  stopWatchSeconds = querySelector('#stopwatch_seconds');
  stopWatchHours.text = '00';
  stopWatchMinutes.text = '00';
  stopWatchSeconds.text = '00';
  timer = Stopwatch();
}

void attachEventHandlers() {
  startButton.onClick.listen(startTimer);
  stopButton.onClick.listen(endTimer);
  learnedItem.onChange.listen(addLearnedItem);
}

void checkLocalStorage() {
  if (window.localStorage.isNotEmpty == true) {
    history.children.clear();
    window.localStorage.forEach((key, value) {
      var newHistory = LIElement();
      newHistory.text = '${key} - ${value.substring(0, 7)}';
      history.children.add(newHistory);
    });
  } else {
    var newHistory = LIElement();
    newHistory.text = "Learn something first :)";
    history.children.add(newHistory);
  }
}

void addLearnedItem(Event event) {
  mainItem.text = learnedItem.value;
  learnedItem.value = '';
  timer.reset();
  startButton.removeAttribute('disabled');
}

void startTimer(Event e) {
  timer.start();
  startButton.attributes['disabled'] = 'true';
  stopButton.removeAttribute('disabled');
  const oneSec = Duration(seconds: 1);
  Timer.periodic(oneSec, (Timer t) => refreshTimer());
}

void endTimer(Event e) {
  timer.stop();
  startButton.removeAttribute('disabled');
  stopButton.attributes['disabled'] = 'true';
  itemWithTime[mainItem.text] = timer.elapsed;
  window.localStorage[mainItem.text] = '${timer.elapsed}';
  checkLocalStorage();
}

void refreshTimer() {
  stopWatchHours.text = ('0${timer.elapsed.toString().substring(0, 1)}');
  stopWatchMinutes.text = ('${timer.elapsed.toString().substring(2, 4)}');
  stopWatchSeconds.text = ('${timer.elapsed.toString().substring(5, 7)}');
}
