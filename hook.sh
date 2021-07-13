cnda()
{
    _cnda_out="$(/home/elmjag/cnda/cnda $@)"
    _cnda_exit_code=$?

    if [[ "$_cnda_exit_code" -ne 0 ]]; then
        echo "$_cnda_out"
        return
    fi

    $_cnda_out
}
