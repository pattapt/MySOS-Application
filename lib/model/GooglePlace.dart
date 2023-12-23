// To parse this JSON data, do
//
//     final googlePlace = googlePlaceFromJson(jsonString);

import 'dart:convert';

GooglePlace googlePlaceFromJson(String str) => GooglePlace.fromJson(json.decode(str));

String googlePlaceToJson(GooglePlace data) => json.encode(data.toJson());

class GooglePlace {
    List<dynamic>? htmlAttributions;
    Result? result;
    String? status;

    GooglePlace({
        this.htmlAttributions,
        this.result,
        this.status,
    });

    factory GooglePlace.fromJson(Map<String, dynamic> json) => GooglePlace(
        htmlAttributions: json["html_attributions"] == null ? [] : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "html_attributions": htmlAttributions == null ? [] : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "result": result?.toJson(),
        "status": status,
    };
}

class Result {
    List<AddressComponent>? addressComponents;
    String? adrAddress;
    String? businessStatus;
    CurrentOpeningHours? currentOpeningHours;
    String? formattedAddress;
    String? formattedPhoneNumber;
    Geometry? geometry;
    String? name;
    OpeningHours? openingHours;
    List<Photo>? photos;
    double? rating;
    List<Review>? reviews;
    bool? wheelchairAccessibleEntrance;

    Result({
        this.addressComponents,
        this.adrAddress,
        this.businessStatus,
        this.currentOpeningHours,
        this.formattedAddress,
        this.formattedPhoneNumber,
        this.geometry,
        this.name,
        this.openingHours,
        this.photos,
        this.rating,
        this.reviews,
        this.wheelchairAccessibleEntrance,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
        adrAddress: json["adr_address"],
        businessStatus: json["business_status"],
        currentOpeningHours: json["current_opening_hours"] == null ? null : CurrentOpeningHours.fromJson(json["current_opening_hours"]),
        formattedAddress: json["formatted_address"],
        formattedPhoneNumber: json["formatted_phone_number"],
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
        name: json["name"],
        openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
        photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
        rating: json["rating"]?.toDouble(),
        reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
        wheelchairAccessibleEntrance: json["wheelchair_accessible_entrance"],
    );

  get isNotEmpty => null;

    Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "adr_address": adrAddress,
        "business_status": businessStatus,
        "current_opening_hours": currentOpeningHours?.toJson(),
        "formatted_address": formattedAddress,
        "formatted_phone_number": formattedPhoneNumber,
        "geometry": geometry?.toJson(),
        "name": name,
        "opening_hours": openingHours?.toJson(),
        "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
        "rating": rating,
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "wheelchair_accessible_entrance": wheelchairAccessibleEntrance,
    };
}

class AddressComponent {
    String? longName;
    String? shortName;
    List<String>? types;

    AddressComponent({
        this.longName,
        this.shortName,
        this.types,
    });

    factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class CurrentOpeningHours {
    bool? openNow;
    List<CurrentOpeningHoursPeriod>? periods;
    List<String>? weekdayText;

    CurrentOpeningHours({
        this.openNow,
        this.periods,
        this.weekdayText,
    });

    factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) => CurrentOpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null ? [] : List<CurrentOpeningHoursPeriod>.from(json["periods"]!.map((x) => CurrentOpeningHoursPeriod.fromJson(x))),
        weekdayText: json["weekday_text"] == null ? [] : List<String>.from(json["weekday_text"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "open_now": openNow,
        "periods": periods == null ? [] : List<dynamic>.from(periods!.map((x) => x.toJson())),
        "weekday_text": weekdayText == null ? [] : List<dynamic>.from(weekdayText!.map((x) => x)),
    };
}

class CurrentOpeningHoursPeriod {
    Close? close;
    Close? open;

    CurrentOpeningHoursPeriod({
        this.close,
        this.open,
    });

    factory CurrentOpeningHoursPeriod.fromJson(Map<String, dynamic> json) => CurrentOpeningHoursPeriod(
        close: json["close"] == null ? null : Close.fromJson(json["close"]),
        open: json["open"] == null ? null : Close.fromJson(json["open"]),
    );

    Map<String, dynamic> toJson() => {
        "close": close?.toJson(),
        "open": open?.toJson(),
    };
}

class Close {
    DateTime? date;
    int? day;
    String? time;
    bool? truncated;

    Close({
        this.date,
        this.day,
        this.time,
        this.truncated,
    });

    factory Close.fromJson(Map<String, dynamic> json) => Close(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        day: json["day"],
        time: json["time"],
        truncated: json["truncated"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "day": day,
        "time": time,
        "truncated": truncated,
    };
}

class Geometry {
    Location? location;
    Viewport? viewport;

    Geometry({
        this.location,
        this.viewport,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "viewport": viewport?.toJson(),
    };
}

class Location {
    double? lat;
    double? lng;

    Location({
        this.lat,
        this.lng,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class Viewport {
    Location? northeast;
    Location? southwest;

    Viewport({
        this.northeast,
        this.southwest,
    });

    factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
    };
}

class OpeningHours {
    bool? openNow;
    List<OpeningHoursPeriod>? periods;
    List<String>? weekdayText;

    OpeningHours({
        this.openNow,
        this.periods,
        this.weekdayText,
    });

    factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null ? [] : List<OpeningHoursPeriod>.from(json["periods"]!.map((x) => OpeningHoursPeriod.fromJson(x))),
        weekdayText: json["weekday_text"] == null ? [] : List<String>.from(json["weekday_text"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "open_now": openNow,
        "periods": periods == null ? [] : List<dynamic>.from(periods!.map((x) => x.toJson())),
        "weekday_text": weekdayText == null ? [] : List<dynamic>.from(weekdayText!.map((x) => x)),
    };
}

class OpeningHoursPeriod {
    Open? open;

    OpeningHoursPeriod({
        this.open,
    });

    factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) => OpeningHoursPeriod(
        open: json["open"] == null ? null : Open.fromJson(json["open"]),
    );

    Map<String, dynamic> toJson() => {
        "open": open?.toJson(),
    };
}

class Open {
    int? day;
    String? time;

    Open({
        this.day,
        this.time,
    });

    factory Open.fromJson(Map<String, dynamic> json) => Open(
        day: json["day"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
    };
}

class Photo {
    int? height;
    List<String>? htmlAttributions;
    String? photoReference;
    int? width;

    Photo({
        this.height,
        this.htmlAttributions,
        this.photoReference,
        this.width,
    });

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions: json["html_attributions"] == null ? [] : List<String>.from(json["html_attributions"]!.map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions": htmlAttributions == null ? [] : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
    };
}

class Review {
    String? authorName;
    String? authorUrl;
    String? language;
    String? originalLanguage;
    String? profilePhotoUrl;
    int? rating;
    String? relativeTimeDescription;
    String? text;
    int? time;
    bool? translated;

    Review({
        this.authorName,
        this.authorUrl,
        this.language,
        this.originalLanguage,
        this.profilePhotoUrl,
        this.rating,
        this.relativeTimeDescription,
        this.text,
        this.time,
        this.translated,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        authorName: json["author_name"],
        authorUrl: json["author_url"],
        language: json["language"],
        originalLanguage: json["original_language"],
        profilePhotoUrl: json["profile_photo_url"],
        rating: json["rating"],
        relativeTimeDescription: json["relative_time_description"],
        text: json["text"],
        time: json["time"],
        translated: json["translated"],
    );

    Map<String, dynamic> toJson() => {
        "author_name": authorName,
        "author_url": authorUrl,
        "language": language,
        "original_language": originalLanguage,
        "profile_photo_url": profilePhotoUrl,
        "rating": rating,
        "relative_time_description": relativeTimeDescription,
        "text": text,
        "time": time,
        "translated": translated,
    };
}
