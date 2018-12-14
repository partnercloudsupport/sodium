import 'dart:math';

class News {
  final int id;
  final String title;
  final String cover;
  final DateTime dateCreated;
  final String content;
  final String diff;

  News({
    this.id,
    this.title,
    this.cover,
    this.dateCreated,
    this.content,
    this.diff,
  });

  News copyWith({
    int id,
    String title,
    String cover,
    String category,
    DateTime dateCreated,
    String location,
    String content,
    String diff,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      cover: cover ?? this.cover,
      dateCreated: dateCreated ?? this.dateCreated,
      content: content ?? this.content,
      diff: diff ?? this.diff,
    );
  }

  static String getRandomImage() {
    final images = [
      'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GTNH9jFDwHeMF8A5a0.jpg',
      'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GTNH9jFDwHeMF8A5a0.jpg',
      'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GRg31UJbRB28g0TWku.jpg',
      'https://www.thairath.co.th/media/T18CT60ObSbLrsQ6mSJ5lh0Aqlhd1EYskhqtXXFF9xFFslvFhb3I7Na.jpg',
      'https://www.thairath.co.th/media/T18CT60ObSbLrsQ6mF1liTdKsNNoU4TIXtZVYf76RTbtPQQaDKH9ziK.jpg',
      'https://www.thairath.co.th/media/T18CT60ObSbLrsQ6mFzYFmwspfFpzOlLFehhfKeFwdVzdIoxLk4aHpD.jpg',
      'https://www.thairath.co.th/media/T18CT60ObSbLrsQ6l7ITh4ksk8bB5ldm4yBRxUM6WbTl0M0S1DPudc3.jpg',
      'https://www.thairath.co.th/media/T18CT60ObSbLrsQ6l7QKkAg3eoFG9G7z1Bttbw5ulx0VtVVyHq9PNa1.jpg'
    ];

    final index = Random().nextInt(images.length);
    return images[index];
  }

  static String getRandomTitle() {
    final titles = [
      'ศน.ติวเทคนิคเผยแผ่พระธรรมวิทยากร',
      'แผนเผยแผ่พุทธชู “ศีล-สมาธิ-ปัญญา” ',
      'อิตาลีให้เผยแผ่พุทธ',
      'สวดมนต์ทั้งปี ทำสมาธิ ๙ นาที สร้างความดีได้ทุกวัย',
      'มส.ผุดทีมเกาะติดข่าวกระทบพุทธศาสนา ',
      'ฆ่าตัวตาย ตกนรก',
      'มติสมัชชาฯชงรัฐหนุนการเผยแผ่พุทธ',
    ];

    final index = Random().nextInt(titles.length);
    return titles[index];
  }

  static List<News> generate() {
    return [
      News(
        title: 'นานาทัศนะกิจของสงฆ์ เห็นใจเครียดเรียนหนัก',
        cover: 'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GTNH9jFDwHeMF8A5a0.jpg',
        dateCreated: DateTime.now(),
        content: '[{"insert":"นายสุวพันธุ์ ตันยุวรรธนะ รัฐมนตรีประจำ สำนักนายกรัฐมนตรี ที่กำกับดูแลสำนักงานพระพุทธศาสนาแห่งชาติ (พศ.) กล่าวว่า จากการตรวจเยี่ยมการดำเนินการตามโครงการ\n"}]',
      ),
      News(
        title: 'เฟ้น 1,500 วัด ประชารัฐสร้างสุข',
        cover: 'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GRiV8huA7VMniLOKSB.jpg',
        dateCreated: DateTime.now(),
        content: '[{"insert":"นายสุวพันธุ์ ตันยุวรรธนะ รัฐมนตรีประจำ สำนักนายกรัฐมนตรี ที่กำกับดูแลสำนักงานพระพุทธศาสนาแห่งชาติ (พศ.) กล่าวว่า จากการตรวจเยี่ยมการดำเนินการตามโครงการ\n"}]',
      ),
      News(
        title: 'รมว.วัฒนธรรม ฝากประชาชนมีสติ อย่ายึดตัวบุคคล บั่นทอนศรัทธาพุทธศาสนา',
        cover: 'https://www.thairath.co.th/media/CiHZjUdJ5HPNXJ92GRg31UJbRB28g0TWku.jpg',
        dateCreated: DateTime.now(),
        content:
            '[{"insert":"ความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทำไมไม่มีอะไรให้มันดีจริงงงุ__\nความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทำไมไม่มีอะไรให้มันดีจริงงงุ_ำไมไม่มีอะไรให้มันดีจริงงงุ_\nความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทำไมไม่มีอะไรให้มันดีจริงงงุ__\nความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทความรักของฉันที่มันจะเกิดจากการใช้งานในการใช้งานในการจัดการศึกษาและผู้ส่งที่รวดร้าวของพรรคประชาธิปัตย์กล่าวว่าการที่มีความรู้และความมั่นใจว่าทำไมไม่มีอะไรให้มันดีจริงงงุ_ำไมไม่มีอะไรให้มันดีจริงงงุ_\n\n\n\n\n"}]',
      ),
    ];
  }
}
