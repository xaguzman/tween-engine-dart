part of tweenengine;

/**
 * A light pool of objects that can be resused to avoid allocation.
 * Based on Nathan Sweet pool implementation
 */
class Pool<T> {
  List<T> _objects;
  Callback<T> _callback;

  InstanceCreator<T> create;

  Pool(Callback<T> this._callback) {
    this._objects = new List();
  }

  T get() {
    T obj = _objects.isEmpty ? create() : _objects.removeAt(_objects.length - 1);
    if (_callback != null) _callback.onUnPool(obj);
    return obj;
  }

  void free(T obj) {
    if (!_objects.contains(obj)) {
      if (_callback != null) _callback.onPool(obj);
      _objects.add(obj);
    }
  }

  void clear() {
    _objects.clear();
  }

  int size() {
    return _objects.length;
  }

  void ensureCapacity(int minCapacity) {
    //_objects.ensureCapacity(minCapacity);
  }
  
}

typedef void CallbackAction<T>(T obj);
typedef T InstanceCreator<T>();

class Callback<T> {
  CallbackAction onPool;
  CallbackAction onUnPool;
  
  Callback([this.onPool, this.onUnPool]);
}