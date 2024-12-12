class PolicyModel {
    PolicyModel({
        required this.code,
        required this.message,
        required this.status,
        required this.data,
    });

    final String? code;
    final String? message;
    final String? status;
    final List<Datum> data;

    factory PolicyModel.fromJson(Map<String, dynamic> json){ 
        return PolicyModel(
            code: json["code"],
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.cmsPageTitle,
        required this.cmsFullUrl,
    });

    final String? cmsPageTitle;
    final String? cmsFullUrl;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            cmsPageTitle: json["cms_page_title"],
            cmsFullUrl: json["cms_full_url"],
        );
    }

}
