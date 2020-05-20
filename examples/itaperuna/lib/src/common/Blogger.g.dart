part of 'Blogger.dart';

class FeedResult {
  final String version;
  final String encoding;
  final Feed feed;

  const FeedResult({
    this.version,
    this.encoding,
    this.feed,
  });

  factory FeedResult.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return FeedResult(
      version: json.find('version'),
      encoding: json.find('encoding'),
      feed: Feed.fromJson(json.find('feed')),
    );
  }
}

class Feed {
  final String id;
  final DateTime updated;
  final List<String> category;
  final String title;
  final String subtitle;
  final List<Link> link;
  final Author author;
  final int total;
  final int offset;
  final int size;
  final List<Entry> rows;

  const Feed({
    this.id,
    this.updated,
    this.category,
    this.title,
    this.subtitle,
    this.link,
    this.author,
    this.total,
    this.offset,
    this.size,
    this.rows,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json.find("id.\$t"),
      updated: DateTime.parse(json.find("updated.\$t")),
      category: json
          .find<List>("category")
          .map<String>((i) => i["term"])
          .toList(),
      title: json.find("title.\$t"),
      subtitle: json.find("subtitle.\$t"),
      link: json
          .find<List>("link")
          .map<Link>((link) => Link.fromJson(link))
          .toList(),
      author: Author.fromJson(json.find<List>('author', [])[0]),
      total: int.tryParse(json.find("openSearch\$totalResults.\$t")),
      offset: int.tryParse(json.find("openSearch\$startIndex.\$t")),
      size: int.tryParse(json.find("openSearch\$itemsPerPage.\$t")),
      rows: json
          .find<List>("entry", [])
          .map<Entry>((entry) => Entry.fromJson(entry))
          .toList(),
    );
  }
}

class Link {
  final String rel;
  final String type;
  final String href;

  const Link({
    this.rel,
    this.type,
    this.href,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      rel: json.find("rel"),
      type: json.find("type"),
      href: json.find("href"),
    );
  }
}

class Author {
  final String name;
  final String uri;
  final String email;
  final String image;

  const Author({
    this.name,
    this.uri,
    this.email,
    this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json.find("name.\$t"),
      uri: json.find("uri.\$t"),
      email: json.find("email.\$t"),
      image: json.find("gd\$image.src"),
    );
  }
}

class Entry {
  final String id;
  final DateTime published;
  final DateTime updated;
  final List<String> category;
  final String title;
  final String content;
  final String thumbnail;
  final List<Link> link;
  final Author author;
  final int total;

  const Entry({
    this.id,
    this.published,
    this.updated,
    this.category,
    this.title,
    this.content,
    this.thumbnail,
    this.link,
    this.author,
    this.total,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json.find("id.\$t"),
      published: DateTime.parse(json.find("published.\$t")),
      updated: DateTime.parse(json.find("updated.\$t")),
      category: json
          .find<List>("category")
          .map<String>((i) => i["term"])
          .toList(),
      title: json.find("title.\$t"),
      content: json.find("content.\$t"),
      thumbnail: json.find("media\$thumbnail.url"),
      link: json
          .find<List>("link")
          .map<Link>((link) => Link.fromJson(link))
          .toList(),
      author: Author.fromJson(json.find<List>('author', [])[0]),
      total: int.tryParse(json.find("thr\$total.\$t")),
    );
  }
}