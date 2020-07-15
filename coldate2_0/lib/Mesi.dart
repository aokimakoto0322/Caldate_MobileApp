class Mesi {
  String mesiname;
  int mesical;

  Mesi(this.mesiname, this.mesical);

  Mesi.fromJson(Map<String, dynamic> json) {
    mesiname = json['mesiname'];
    mesical = json['mesical'];
  }
}
