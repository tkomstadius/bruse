function addTags(){
  var tags = $("#tag_name").val().split(' ')
  var file_id = $("#tag_file_id").val()

  var post_data = {
    file_id: file_id,
    tags: tags
  }

  $.post('/tags.json', post_data, function(data){
    window.location.replace('/files');
  });
}
