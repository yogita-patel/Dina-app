import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../registerAccountModel/register_account_model.dart';

part 'account_info_model.g.dart';

@JsonSerializable()
class AccountInfoModel extends BaseModel {
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? fax;
  int? status;
  List<CustomField>? customField;
  @JsonKey(name: "sector")
  Sector? sector;

  AccountInfoModel(
      {this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.fax,
        this.status,
      this.customField,
      this.sector});

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccountInfoModelToJson(this);
}
@JsonSerializable()
class Sector {
  String? fieldname;
  String? type;
  List<SectorOption>? options;
  @JsonKey(name: 'selected_sector')
  int? selectedSector;

  Sector({this.fieldname, this.type, this.options, this.selectedSector});

  factory Sector.fromJson(Map<String, dynamic> json) => _$SectorFromJson(json);
  Map<String, dynamic> toJson() => _$SectorToJson(this);

  @override
  String toString() => 'Sector{fieldname: $fieldname, type: $type, options: $options, selectedSector: $selectedSector}';
}

@JsonSerializable()
class SectorOption {
  int? id;
  String? name;

  SectorOption({this.id, this.name});

  factory SectorOption.fromJson(Map<String, dynamic> json) => _$SectorOptionFromJson(json);
  Map<String, dynamic> toJson() => _$SectorOptionToJson(this);

  @override
  String toString() => 'SectorOption{id: $id, name: $name}';
}
