for project in $(bq ls --projects | awk '{print $1}' | grep -v "project_id" | tail -n +3); do
   echo "❔ Project: $project"
   
   for dataset in $(bq ls --datasets --project_id=$project --max_results=1000 | awk '{print $1}' | grep -E '^(analytics_)'); do
        echo "    ❔ Dataset: $project:$dataset..."

        dataset_expiration=$(bq show --project_id=$project $dataset | grep 'Default table expiration')
        if [ -z "$dataset_expiration" ]; then
            echo "    ✅ Dataset: $project:$dataset does not have expiration"
        else
            echo "    ❌ Dataset: $project:$dataset expiration: $dataset_expiration"
        fi

        for table in $(bq ls --max_results=1000 $project:$dataset | awk '{print $1}' | grep -E '^(events_|pseudonymous_users_|users_)'); do
            table_id=$dataset.$table
            
            table_expiration=$(bq show --project_id=$project $table_id | awk NR==5 | grep -oP '\b\d{2} \w{3} \d{2}:\d{2}:\d{2}\b' | awk NR==2)
            if [ -z "$table_expiration" ]; then
                echo "        ✅ Table: $project:$table_id does not have expiration"
            else
                echo "        ❌ Table: $project:$table_id expiration: $table_expiration"
                bq update --project_id=$project --expiration=0 $table_id
                echo "        ✅ Table: $project:$table_id expiration removed"
            fi
        done
    done
done