class ModelsConstant {
    String name;
    String repo;
    String file;

    ModelsConstant({
      required this.name, 
      required this.repo, 
      required this.file});

    get downloadLink{
      return "https://huggingface.co/${repo}/resolve/main/${file}?download=true";
    }

    factory ModelsConstant.fromJson(Map<String, dynamic> json) {
      return ModelsConstant(
        name: json['name'], 
        repo: json['repo'], 
        file: json['file'],);
  }
}