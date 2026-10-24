function onCreatePost()
{
	var option = optionsArray[3];
	if (option.name != Lang.str('opt_coloredui', 'Colored UI:')) return;
	option.options.insert(1, 'Enabled DX');
	option.storedValues.insert(1, 'Enabled DX');
}