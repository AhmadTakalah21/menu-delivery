


import 'dart:convert';

List<Agent> dataAgentFromJson(var str) =>
    List<Agent>.from(
        json.decode(str).map((x) => Agent.fromJson(x)));



class Agent {
  int? agentId;
  String? name;

  Agent({this.agentId, this.name});

  Agent.fromJson(Map<String, dynamic> json) {
    agentId = json['agent_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agent_id'] = agentId;
    data['name'] = this.name;
    return data;
  }
}
